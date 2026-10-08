#!/bin/bash
cd -- "$(dirname -- "${BASH_SOURCE[0]}")" || exit 1
mkdir -p ~/.config/nvim
mkdir -p ~/.config/gtk-4.0
ln -sf $PWD/init.vim ~/.config/nvim/
ln -sf $PWD/coc-settings.json ~/.config/nvim/
ln -sf $PWD/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
echo "source $PWD/bashrc" >> ~/.bashrc
ln -sf $PWD/dircolors ~/.dircolors
ln -sf $PWD/gitconfig ~/.gitconfig
ln -sf $PWD/DEFAULT_AGENTS.md ~/AGENTS.md

mkdir -p ~/.claude ~/.codex
python3 - <<'PYCODE'
import os
import re
from pathlib import Path

config = Path(os.environ.get("CODEX_HOME", str(Path.home() / ".codex"))) / "config.toml"
config.parent.mkdir(parents=True, exist_ok=True)
lines = config.read_text().splitlines(keepends=True) if config.exists() else []
result = ["project_doc_max_bytes = 0\n"]
in_table = False
for line in lines:
    if line.lstrip().startswith("["):
        in_table = True
    if not in_table and re.match(r"\s*project_doc_max_bytes\s*=", line):
        continue
    result.append(line)
text = "".join(result)
section = re.search(r"(?m)^\[tui\.keymap\.composer\][^\n]*(?:\n|$)", text)
if section:
    following = re.search(r"(?m)^\s*\[", text[section.end():])
    end = section.end() + following.start() if following else len(text)
    body = text[section.end():end]
    body = re.sub(r"(?m)^\s*queue\s*=\s*(?:\[[^\]]*\]|[^\n]*)[^\n]*(?:\n|$)", "", body)
    text = text[:section.end()].rstrip("\n") + "\nqueue = []\n" + body + text[end:]
else:
    text = text.rstrip("\n") + "\n\n[tui.keymap.composer]\nqueue = []\n"
config.write_text(text)
PYCODE
rm -rf ~/.claude/commands && ln -sfn $PWD/skills ~/.claude/commands   # Claude Code
rm -rf ~/.codex/prompts  && ln -sfn $PWD/skills ~/.codex/prompts      # Codex

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo apt install ripgrep silversearcher-ag unzip ptyxis

curl -fsSL https://raw.githubusercontent.com/clojure-lsp/clojure-lsp/master/install -o /tmp/clojure-lsp-install.sh
sudo bash /tmp/clojure-lsp-install.sh
rm -f /tmp/clojure-lsp-install.sh

curl -sL https://deb.nodesource.com/setup_25.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt install nodejs

nvim --headless +'PlugInstall --sync' +qa
nvim --headless +'CocInstall -sync coc-pyright' +qa
