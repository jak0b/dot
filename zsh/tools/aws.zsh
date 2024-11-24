function aws-load() {
  if [ ! -d "${HOME}/.aws/.env" ]; then
    mkdir -p "${HOME}/.aws/.env"
  fi

  if [ -f "${HOME}/.aws/.env/AWS_PROFILE" ]; then
    export AWS_PROFILE="$(< $HOME/.aws/.env/AWS_PROFILE)"
  fi

  if [ -f "${HOME}/.aws/.env/AWS_REGION" ]; then
    export AWS_REGION="$(< $HOME/.aws/.env/AWS_REGION)"
  fi
} && aws-load && unset -f aws-load

function aws() {
  case $1 in
    profile)
      if [[ $2 = "current" ]] && [[ -f $HOME/.aws/.env/AWS_PROFILE ]]
      then cat "$HOME/.aws/.env/AWS_PROFILE"
      else
        local profiles=$(awk '/profile/{ print substr($2, 1, length($2)-1) }' ~/.aws/config)
        local selected=$(echo "$profiles" | fzf --header 'Select AWS profile') || die 'no profile selected'
        echo "$selected" > $HOME/.aws/.env/AWS_PROFILE
        export AWS_PROFILE="$selected"
      fi
      ;;
    region)
      if [[ $2 = "current" ]] && [[ -f $HOME/.aws/.env/AWS_REGION ]]
      then cat "$HOME/.aws/.env/AWS_REGION"
      else
        local regions="$(curl -s 'https://raw.githubusercontent.com/boto/botocore/refs/heads/develop/botocore/data/endpoints.json' \
                         | jq -r '.partitions[0].regions | to_entries | .[] | "\(.key)\t\(.value.description)"')"
        local selected=$(echo "$regions" | fzf --header 'Select AWS region' | cut -f1) || die 'no profile selected'
        echo "$selected" > $HOME/.aws/.env/AWS_REGION
        export AWS_REGION="$selected"
      fi
      ;;
    *) command aws "$@" ;;
  esac
}

function s3-bucket-delete-all-versions() {
  local bucket="$1"
  if [[ -z $bucket ]]
  then die 'No bucket'
  fi

  local all_objects=$(aws s3api list-object-versions \
        --bucket "$bucket" \
        --output=json \
        --query='{Objects: Versions[].{Key:Key,VersionId:VersionId}}')
  echo -n "$all_objects"
  # TODO:
  # fix string comparison in case the bucket is empty
  if [[ $all_objects == '{\n    "Objects": null\n}' ]]
  then die 2 'Bucket has no versions'
  fi

  aws s3api delete-objects --bucket "$bucket" --delete "$all_objects"
}

function s3-bucket-enable-versioning() {
  local bucket="$1"
  if [[ -z $bucket ]]
  then die 'do bucket'
  fi

  aws s3api put-bucket-versioning \
      --bucket "$bucket" \
      --versioning-configuration Status=Enabled
}
