HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt appendhistory     # append history to the history file (no overwriting)
setopt sharehistory      # share history across terminals
setopt incappendhistory  # immediately append to the history file, not just when a term is killed
setopt hist_ignore_space # commands starting with a splece won't be added to the history
setopt prompt_subst

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

function preexec() { print -Pn "\e]0;${(q)1}\e\\"; }

# fix keys
# from https://stackoverflow.com/questions/8638012/fix-key-settings-home-end-insert-delete-in-zshrc-when-running-zsh-in-terminat
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

os=$(uname)

ZSH_BASE="$HOME/.config/zsh"

autoload -U compinit && compinit

source $ZSH_BASE/prompt.zsh
source $ZSH_BASE/tools/git.zsh
source $ZSH_BASE/tools/text.zsh
source $ZSH_BASE/tools/network.zsh

if [[ -f $ZSH_BASE/local.zsh ]]
then source $ZSH_BASE/local.zsh
fi

export PATH="${PATH}:$HOME/.local/bin"

setup_prompt && unset -f setup_prompt

function eecho() { 1>&2 echo "$*"; }

function die() {
  if [[ $1 =~ ^[0-9]+$ ]]; then 
    local rc="$1" && shift
  fi
  [[ $# -gt 0 ]] && eecho "$*"
  [[ -n $rc ]] && return "$rc" || return 1
}

case "$os" in
  Linux)
    source $ZSH_BASE/linux/tools.zsh
    FPATH="${FPATH}:/usr/share/zsh/site-functions"

    if (( $+commands[systemctl] ))
    then source $ZSH_BASE/linux/systemd.zsh
    fi

    if (( $+commands[wl-copy] ))
    then
      alias c='wl-copy'
      alias p='wl-paste'
    fi
    ;;
  Darwin)
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
    FPATH="${FPATH}:/opt/homebrew/share/zsh/site-functions"
    source $ZSH_BASE/darwin/tools.zsh
    alias c='pbcopy'
    alias p='pbpaste'
    ;;
esac

alias r="source $ZSH_BASE/zshrc.zsh"

if (( $+commands[kubectl] ))
then source $ZSH_BASE/tools/kubectl.zsh
fi

if (( $+commands[helm] ))
then source $ZSH_BASE/tools/helm.zsh
fi

if (( $+commands[curl] ))
then source $ZSH_BASE/tools/idasen.zsh
fi

if (( $+commands[aws] ))
then source $ZSH_BASE/tools/aws.zsh
fi

(( $+commands[eza] )) && {
  alias ls='eza'
  alias l='ls'
  alias ll='ls -lg'
  alias la='ll -a'
}

(( $+commands[dog] )) && {
  alias A='dog A'
  alias AAAA='dog AAAA'
  alias CNAME='dog CNAME'

  alias MX='dog MX'
  alias SOA='dog SOA'
  alias TXT='dog TXT'
  alias NS='dog NS'
}

(( $+commands[nvim] )) && {
  alias v='nvim'
  alias vy='v -c "set ft=yaml"'
  export EDITOR=nvim
  export VISUAL=nvim
}

(( $+commands[pass] )) && {
  export PASSWORD_STORE_DIR="$HOME/.local/share/pass"
  export PASSWORD_STORE_EXTENSIONS_DIR="$HOME/.local/lib/pass/"
  export PASSWORD_STORE_ENABLE_EXTENSIONS='true'
}

(( $+commands[go] )) && {
  export GOPATH="$HOME/Programming/go"
  export PATH="$PATH:$GOPATH/bin"
}

(( $+commands[cargo] )) && {
  export PATH="$PATH:$HOME/.cargo/bin"
}

if (( $+commands[fzf] )); then
  case "$os" in
    Darwin)
      if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
        PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
      fi
      [[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null
      source '/opt/homebrew/opt/fzf/shell/key-bindings.zsh'
      ;;
    Linux)
      [[ $- == *i* ]] && source "/usr/share/fzf/completion.zsh" 2> /dev/null
      source '/usr/share/fzf/key-bindings.zsh'
      ;;
  esac
fi

function alias_config() {
  local name="$1" config_path="$2"
  [[ -n $EDITOR ]] && alias "$name"conf="$EDITOR $config_path"
}; {
  alias_config zsh     "$HOME/.config/zsh/"
  alias_config ssh     "$HOME/.ssh/config"
  alias_config nvim    "$HOME/.config/nvim"
  alias_config term    "$HOME/.config/wezterm/wezterm.lua"
} && unset -f alias_config

function cd_dots_alias() {
  local dots=".." path="../"

  for i in {1..$1}; do
    alias ${dots}="cd ${path}"
    dots="${dots}."; path="${path}../"
  done
} && cd_dots_alias 6 && unset -f cd_dots_alias

compinit
source ~/.config/environment.d/ssh_auth_socket.conf
export SSH_AUTH_SOCK
