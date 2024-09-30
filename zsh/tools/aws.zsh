if [ ! -d "${HOME}/.aws/.env" ]; then
  mkdir -p "${HOME}/.aws/.env"
fi

if [ -f "${HOME}/.aws/.env/AWS_PROFILE" ]; then
  export AWS_PROFILE="$(< $HOME/.aws/.env/AWS_PROFILE)"
fi

if [ -f "${HOME}/.aws/.env/AWS_REGION" ]; then
  export AWS_REGION="$(< $HOME/.aws/.env/AWS_REGION)"
fi

function aws() {
  case $1 in
    profile)
      if [ -n "$2" ] && [ "$2" = "current" ] && [ -f "$HOME/.aws/cli/current_profile"  ]; then
        cat "$HOME/.aws/cli/current_profile"
      else
        local profiles=$(awk '/profile/{ print substr($2, 1, length($2)-1) }' ~/.aws/config)
        local selected_profile=$(echo "$profiles" | fzf --header 'Select AWS profile' --preview 'cat ~/.aws/config') || return
        echo "$selected_profile" > $HOME/.aws/cli/current_profile
        export AWS_PROFILE="$selected_profile"
      fi
      ;;
    region)
      echo $AWS_REGION
      ;;
    *)
      command aws "$@"
  esac
}

