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

function preexec() { print -Pn "\e]0;${(q)1}\e\\"; }

# fix keys
# from https://stackoverflow.com/questions/8638012/fix-key-settings-home-end-insert-delete-in-zshrc-when-running-zsh-in-terminat
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  # PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➢ %f'
else # root
  PR_USER='%F{red}%n%f'
  # PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➢ %f'
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
  PR_HOST='%F{red}%M%f' # SSH
else
  PR_HOST='%F{green}%m%f' # no SSH
fi

return_code="%(?..%F{red}%?↲ %f)"

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

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}⟪"
ZSH_THEME_GIT_PROMPT_SUFFIX="⟫ %f"
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}⟪"
ZSH_THEME_RUBY_PROMPT_SUFFIX="⟫%f"

os=$(uname)

alias reload='source ~/.zshrc'

ZSH_BASE="$HOME/.config/zsh"

source $ZSH_BASE/git/lib.zsh
source $ZSH_BASE/git/aliases.zsh
source $ZSH_BASE/tools/text.zsh

export PATH="${PATH}:$HOME/.local/bin"

case "$os" in
  Linux)
    source $ZSH_BASE/linux/tools.zsh
    FPATH="${FPATH}:/usr/share/zsh/site-functions"
    ;;
  Darwin)
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
    source $ZSH_BASE/darwin/tools.zsh
    ;;
esac

autoload -U compinit && compinit
autoload -U colors && colors

if (( $+commands[systemctl] ))
then source $ZSH_BASE/linux/systemd.zsh
fi

if (( $+commands[sway] ))
then source $ZSH_BASE/linux/sway.zsh
fi

if (( $+commands[kubectl] ))
then source $ZSH_BASE/tools/kubectl.zsh
fi

if (( $+commands[helm] ))
then source $ZSH_BASE/tools/helm.zsh
fi

if (( $+commands[wg] ))
then source $ZSH_BASE/tools/wireguard.zsh
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

if (( $+commands[fzf] )); then
  case "$os" in
    Darwin)
      if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
        PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
      fi
      [[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null
      source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
      ;;
    Linux)
      [[ $- == *i* ]] && source "/usr/share/fzf/completion.zsh" 2> /dev/null
      source "/usr/share/fzf/key-bindings.zsh"
      ;;
  esac
fi

alias_config() {
  local name="$1" config_path="$2"
  [[ -n $EDITOR ]] && alias "$name"conf="$EDITOR $config_path"
}; {
  alias_config zsh     "$HOME/.config/zsh/"
  alias_config ssh     "$HOME/.ssh/config"
  alias_config nvim    "$HOME/.config/nvim"
  alias_config term    "$HOME/.config/wezterm/wezterm.lua"
} && unset -f alias_config

function cd_dots_alias() {
  local dots=".."
  local path="../"

  for i in {1..$1}; do
    alias ${dots}="cd ${path}"
    dots="${dots}."; path="${path}../"
  done
}
cd_dots_alias 6 && unset -f cd_dots_alias
