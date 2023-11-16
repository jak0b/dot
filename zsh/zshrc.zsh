if [ "$(uname)" = "Darwin" ]
  then OS_DARWIN=true;
elif [ "$(uname)" = "Linux" ]
  then OS_LINUX=true;
fi

alias zsh-reload='source ~/.zshrc'

ZSH_BASE="$HOME/.config/zsh"

if $OS_DARWIN
then
  FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
fi

autoload -U compinit && compinit
autoload -U colors && colors

if $OS_DARWIN
then
  export PATH="/opt/homebrew/bin:${PATH}"
  export PATH="/opt/homebrew/sbin:${PATH}"
fi

export PATH="$HOME/.local/bin:${PATH}"

if [ -d "$HOME/.local/scripts" ]
then
  export PATH="${PATH}:$HOME/.local/scripts"
fi

export ZSH_CACHE_DIR=$HOME/.cache/zsh
if [ ! -d "$ZSH_CACHE_DIR" ]
then
  mkdir "$ZSH_CACHE_DIR"
fi

function preexec() {
  print -Pn "\e]0;${(q)1}\e\\"
}

export PASSWORD_STORE_DIR=~/.local/share/pass

HISTFILE=~/.zsh_history

HISTSIZE=100000
SAVEHIST=100000

setopt appendhistory     # append history to the history file (no overwriting)
setopt sharehistory      # share history across terminals
setopt incappendhistory  # immediately append to the history file, not just when a term is killed
setopt hist_ignore_space # commands starting with a splece won't be added to the history
setopt prompt_subst

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

function echoerr() {
  echo "$@" 1>&2;
}

# fix keys
# from https://stackoverflow.com/questions/8638012/fix-key-settings-home-end-insert-delete-in-zshrc-when-running-zsh-in-terminat
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char


# ██████╗ ██████╗  ██████╗ ███╗   ███╗██████╗ ████████╗
# ██╔══██╗██╔══██╗██╔═══██╗████╗ ████║██╔══██╗╚══██╔══╝
# ██████╔╝██████╔╝██║   ██║██╔████╔██║██████╔╝   ██║   
# ██╔═══╝ ██╔══██╗██║   ██║██║╚██╔╝██║██╔═══╝    ██║   
# ██║     ██║  ██║╚██████╔╝██║ ╚═╝ ██║██║        ██║   
# ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝╚═╝        ╚═╝   

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  # PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  # PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f' # SSH
else
  PR_HOST='%F{green}%m%f' # no SSH
fi

return_code="%(?..%F{red}%? ↵%f)"

user_host="${PR_USER}%F{cyan}@${PR_HOST}"
current_dir="%B%F{blue}%~%f%b"
git_branch='$(git_prompt_info)'

# disable vi keys
# bindkey -v

function zle-line-init zle-keymap-select {
    case ${KEYMAP} in
        (vicmd)
PROMPT="${user_host} ${current_dir} ${git_branch}▨
$PR_PROMPT " ;;
        (*)
PROMPT="${user_host} ${current_dir} ${git_branch}
$PR_PROMPT " ;;
    esac
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

RPROMPT="${return_code}"

# unset return_code user_host current_dir git_branch
# unset PR_USER PR_HOST PR_PROMPT

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"

source $ZSH_BASE/git/lib.zsh
source $ZSH_BASE/git/aliases.zsh

if $OS_LINUX
then
  source $ZSH_BASE/linux/systemd.zsh
  source $ZSH_BASE/linux/sway.zsh
  source $ZSH_BASE/linux/tools.zsh
fi

if $OS_DARWIN
then
  source $ZSH_BASE/darwin/tools.zsh
fi

if (( $+commands[kubectl] ))
then source $ZSH_BASE/tools/kubectl.zsh
fi

if (( $+commands[helm] ))
then source $ZSH_BASE/tools/helm.zsh
fi

alias_check() {
  local als=$(echo $1 | cut -f1 -d=)
  local cmd=$(echo $1 | cut -f2 -d=)

  if command -v "$cmd" &>/dev/null; then
    alias "$als=$cmd"
  else
    return 1
  fi
}

alias_config() {
  local name="$1"
  local config_path="$2"

  if [ -n "$EDITOR" ]; then
    alias "$name"conf="$EDITOR $config_path"
  else
    return 1
  fi
}

function pubip() {
  local ip_version="${1:-64}"
  local rsp=$(curl -s "https://api${ip_version}.ipify.org")
  echo "$rsp"
}

alias_check ls=eza && {
  alias l='ls'
  alias ll='ls -lg'
  alias la='ll -a'
}

alias_check ns=dog && { 
  alias A='ns A'
  alias AAAA='ns AAAA'
  alias CNAME='ns CNAME'

  alias MX='ns MX'
  alias SOA='ns SOA'
  alias TXT='ns TXT'
  alias NS='ns NS'
}

alias_check v=nvim && {
  alias vy='v -c "set ft=yaml"'
  export EDITOR=nvim
  export VISUAL=nvim
}

alias_config zsh     "$HOME/.zshrc"
alias_config ssh     "$HOME/.ssh/config"
alias_config sshkn   "$HOME/.ssh/known_hosts"
alias_config nvim    "$HOME/.config/nvim/init.lua"
alias_config term    "$HOME/.config/wezterm/wezterm.lua"

export GOPATH=$HOME/Programming/go

export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:${HOME}/.cargo/bin"
export PATH="${PATH}:${HOME}/.krew/bin"

alias ssh-proxy='ssh -TND 1080'

alias _='sudo'

function cd_dots_alias() {
  local dots=".."
  local path="../"

  for i in {1..$1}; do
    alias ${dots}="cd ${path}"
    dots="${dots}."; path="${path}../"
  done
}
cd_dots_alias 6 && unset -f cd_dots_alias

function wg-pair() {
  local priv_key=$(wg genkey)
  local pub_key=$(echo "$priv_key" | wg pubkey)

  if [ "$1" = "-f" ]; then
    echo "$priv_key" > key
    echo "$pub_key" > pub
  else
    echo 'private key:' "$priv_key"
    echo 'public key: ' "$pub_key"
  fi
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
