# Incus notes

This setup uses a remote Incus-based sandbox workflow, and you can also use the same basic setup manually: SSH to the host, then run `incus` commands yourself.

## Getting started

### 1. Install Incus

On a Debian/Ubuntu-style host:

```bash
sudo apt update
sudo apt install -y incus
```

If this is a fresh host, initialize Incus once:

```bash
sudo incus admin init --auto
```

### 2. Create a new container

Create a container from a base image. For this setup, Ubuntu 24.04 is the default:

```bash
incus init images:ubuntu/24.04 my-dev-box
```

Start it:

```bash
incus start my-dev-box
```

If you are managing a remote machine, SSH in first and run the same commands there:

```bash
ssh your-user@your-host
incus init images:ubuntu/24.04 my-dev-box
incus start my-dev-box
```

### 3. Get an interactive bash shell inside the container

```bash
incus exec my-dev-box -- bash
```

If `bash` is not installed in the image, use:

```bash
incus exec my-dev-box -- sh
```

## Network troubleshooting

If a container can start but `apt update` hangs or fails, check whether it actually got an IPv4 address and route:

```bash
incus list
incus exec my-dev-box -- ip -4 a
incus exec my-dev-box -- ip route
incus exec my-dev-box -- ping -c 1 8.8.8.8
incus exec my-dev-box -- getent hosts archive.ubuntu.com
```

On this setup, the common failure mode is that the container only gets IPv6, while the host-side firewall blocks IPv4 DHCP or forwarding on `incusbr0`.

If you use UFW on the host, allow the Incus bridge explicitly:

```bash
sudo ufw allow in on incusbr0
sudo ufw route allow in on incusbr0
sudo ufw route allow out on incusbr0
sudo ufw reload
```

Then renew networking in the container or restart it:

```bash
incus restart my-dev-box
```

## Useful Incus commands

| Task | Command |
| --- | --- |
| List containers | `incus list` |
| Show details for one container | `incus info my-dev-box` |
| Create container without starting it | `incus init images:ubuntu/24.04 my-dev-box` |
| Launch container and start immediately | `incus launch images:ubuntu/24.04 my-dev-box` |
| Start container | `incus start my-dev-box` |
| Stop container | `incus stop my-dev-box` |
| Force-stop container | `incus stop --force my-dev-box` |
| Delete container | `incus delete --force my-dev-box` |
| Open an interactive shell | `incus exec my-dev-box -- bash` |
| Run a one-off command | `incus exec my-dev-box -- uname -a` |
| Run a non-interactive batch command | `incus exec my-dev-box -- sh -lc 'apt update && apt install -y git'` |
| Push a file into container | `incus file push ./localfile my-dev-box/root/localfile` |
| Pull a file out of container | `incus file pull my-dev-box/root/localfile ./localfile` |
| Create snapshot | `incus snapshot create my-dev-box base` |
| List snapshots | `incus info my-dev-box` |
| Restore snapshot in place | `incus snapshot restore my-dev-box base` |
| Create new container from snapshot | `incus copy my-dev-box/base my-dev-box-clone` |
| Start cloned container | `incus start my-dev-box-clone` |
| Show logs / recent state | `incus info my-dev-box --show-log` |
| See configured images | `incus image list` |

## Tooling inside the container

### GitHub Copilot CLI

Install Copilot CLI:

```bash
curl -fsSL https://gh.io/copilot-install | sudo bash
copilot --yolo
```

### Authenticate `gh` and Copilot with a fine-grained PAT

Do not use `copilot /login` or the normal browser/device login flow here. Create a **fine-grained personal access token** on GitHub and use that token inside the container instead.

1. In GitHub, go to **Settings** -> **Developer settings** -> **Personal access tokens** -> **Fine-grained tokens**.
2. Create a token for the owner and repositories you want to use from the container.
3. Grant the minimum repository permissions you need for your workflow.
4. Copy the token and save it in the container, for example:

```bash
mkdir -p ~/.config/gh
chmod 700 ~/.config/gh
printf '%s\n' 'YOUR_FINE_GRAINED_PAT' > ~/.config/gh/pat
chmod 600 ~/.config/gh/pat
```

Then authenticate GitHub CLI with that token and export it for tools that read `GH_TOKEN`:

```bash
gh auth login --hostname github.com --with-token < ~/.config/gh/pat
export GH_TOKEN="$(cat ~/.config/gh/pat)"
```

If you want that environment variable on every shell startup:

```bash
echo 'export GH_TOKEN="$(cat ~/.config/gh/pat)"' >> ~/.bashrc
```

With that in place, both `gh` and Copilot CLI can use the same token-backed authentication without relying on `/login`.

### GitHub CLI (`gh`)

Install GitHub CLI:

```bash
sudo apt update
sudo apt install -y gh
```

### Cloudflare Tunnel (`cloudflared`)

Install `cloudflared` directly from Cloudflare's GitHub releases with a simple container-side setup like this:

```bash
ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
  amd64) ARCH=x86_64 ;;
  arm64) ARCH=arm64 ;;
esac
curl -fsSL "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-${ARCH}" \
  -o /usr/local/bin/cloudflared
chmod +x /usr/local/bin/cloudflared
```

Check it:

```bash
cloudflared --version
```

### Cloudflare API credentials

For the Cloudflare side, you will need:

- an **API token** with **Account: Cloudflare Tunnel: Edit** and **Zone: DNS: Edit**
- your **Cloudflare account ID**
- your **zone name** (apex domain, for example `example.com`)

How to get them:

1. In Cloudflare, create an API token with **Cloudflare Tunnel: Edit** on the account and **DNS: Edit** on the zone.
2. Copy the **account ID** from the Cloudflare dashboard sidebar.
3. Use your domain as the **zone**, for example `example.com`.

If you want to keep them in environment variables for manual setup:

```bash
export CLOUDFLARE_API_TOKEN=...
export CLOUDFLARE_ACCOUNT_ID=...
export CLOUDFLARE_ZONE=example.com
```

The next layer after this is creating a tunnel, adding a DNS record pointing at `<tunnel-id>.cfargotunnel.com`, and then running `cloudflared` with that tunnel's credentials.

## Manual remote workflow

If you want to experiment with the manual workflow, the basic loop is:

```bash
ssh your-user@your-host
incus list
incus exec my-dev-box -- bash
```

That gives you a simple manual version of the same idea: a remote host running Incus containers, with either direct `incus exec` commands or an interactive shell inside the container.
