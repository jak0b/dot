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

s3-bucket-delete-all-versions() {
  local bucket="$1"
  if [ -z "$bucket" ]; then
    echo "No bucket"
    return 1
  fi

  local all_objects=$(aws s3api list-object-versions \
        --bucket "$bucket" \
        --output=json \
        --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')
  echo -n "$all_objects"
  # TODO:
  # fix string comparison in case the bucket is empty
  if [ "$all_objects" = '{\n    "Objects": null\n}' ]; then
    echo "Bucket has no versions"
    return 2
  fi

  aws s3api delete-objects --bucket "$bucket" --delete "$all_objects"
}
