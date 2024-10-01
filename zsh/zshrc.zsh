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

os=$(uname)

alias reload='source ~/.zshrc'

ZSH_BASE="$HOME/.config/zsh"

autoload -U compinit && compinit

source $ZSH_BASE/tools/git.zsh
source $ZSH_BASE/tools/text.zsh
source $ZSH_BASE/tools/network.zsh

export PATH="${PATH}:$HOME/.local/bin"

setup_prompt() {
  autoload -U colors && colors

  GIT_INFO_PREFIX='%F{yellow}⟪ '
  GIT_INFO_SUFFIX=' ⟫ %f'

  local arrow='➢'
  local back_arrow='↲'

  local prompt_user prompt_line prompt_host
  case "$UID" in
    0)
      prompt_user='%F{red}%n%f'
      prompt_line="%F{red}${arrow} %f"
      ;;
    *)
      prompt_user='%F{green}%n%f'
      prompt_line="%f${arrow} %f"
      ;;
  esac

  if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]
  then
    prompt_host='%F{red}%M%f'
  else
    prompt_host='%F{green}%m%f'
  fi

  local user_host="${prompt_user}%F{cyan}@${prompt_host}"
  local dir_info="%B%F{blue}%~%f%b"
  local return_code="%(?..%F{red}%? ${back_arrow} %f)"

  local git_info='$(git_prompt_info)'

  PROMPT="$(printf '%s %s %s\n%s ' "$user_host" "$dir_info" "$git_info" "$prompt_line")"
  RPROMPT="$(printf '%s' "$return_code")"
}
setup_prompt

case "$os" in
  Linux)
    source $ZSH_BASE/linux/tools.zsh
    FPATH="${FPATH}:/usr/share/zsh/site-functions"
    ;;
  Darwin)
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
    source $ZSH_BASE/darwin/tools.zsh
    alias c='pbcopy'
    alias p='pbpaste'
    ;;
esac

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
