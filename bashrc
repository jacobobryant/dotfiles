# vim: ft=bash
alias cljrun='clj -M:run'

export HOMEBREW_NO_ENV_HINTS=true

#PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]$? \[\033[00m\]\[\033[01;36m\]\w\[\033[00m\] \$ '
# a bit darker:
PS1='\[\033]0;\u@\h \W\007\]${debian_chroot:+($debian_chroot)}\u@\h \[\033[0;32m\]$? \[\033[00m\]\[\033[0;36m\]\w\[\033[00m\] \$ '
#LS_COLORS=$LS_COLORS:'di=0;35:' ; export LS_COLORS


set -o vi
alias cp='cp -i'
alias mv='mv -i'
complete -D -o default
alias zprint-fmt="zprint '{:search-config? true}' -w \$(git ls-files --modified)"
alias zprint-files="zprint '{:search-config? true}' -w"
alias gs='git show-branch; git status'
alias ls='ls --color=auto'
alias l='ls --color=auto -lhA'
alias gitwip='git add . && git commit --no-verify -m wip'
alias gitsha='git rev-parse --short HEAD'
alias fly=flyctl
alias vim=nvim

HISTSIZE=100000
HISTFILESIZE=200000

export PATH=$HOME/bin:$PATH

export ALEMBIC_TYBA_SEED_CONTEXT=TestSeed

if [ "$NAME" = "jacob-windows" ]; then
  # wsl
  export MSYS=winsymlinks:nativestrict
  export PATH=~/home/bin:$PATH

  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  #eval "$(pyenv virtualenv-init -)"

	export VISUAL=nvim
	export EDITOR=nvim
else

	export VISUAL=vim
	export EDITOR=vim
  # git bash

  # gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ next-tab '<Primary>Tab'
  # gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ prev-tab '<Primary><Shift>Tab'
  # sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev
  # curl https://pyenv.run | bash
  # pyenv install 3.10
  # pyenv global 3.10
  #export PYENV_ROOT="$HOME/.pyenv"
  #[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  #eval "$(pyenv init -)"
  #eval "$(pyenv virtualenv-init -)"

  export PATH=/c/Users/micro/.local/bin:$PATH

fi
