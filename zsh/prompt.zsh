function setup_prompt() {
  autoload -U colors && colors

  GIT_INFO_PREFIX='%F{yellow}{'
  GIT_INFO_SUFFIX='}%f'
  local arrow='>>'

  local prompt_user prompt_line prompt_host
  case "$UID" in
    0)
      prompt_user='%F{red}%n%f'
      prompt_line="%F{red}${arrow}%f"
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

  local user_host="[${prompt_user}%F{cyan}@${prompt_host}]"
  local dir_info="%B%F{blue}%~%f%b"
  local return_code="%(?..%F{red}%?%f)"

  local git_info='$(git_prompt_info)'

  # [j0b@njord] > /interface/
  PROMPT="$(printf '%s %s %s%s\n%s' "$user_host" "$dir_info" "$git_info" "$return_code" "$prompt_line")"
}
