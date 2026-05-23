function pubip() {
  local url="http://ifconfig.co"
  local cmd=(curl -s)

  if (( ${+VERBOSE} ));
  then local cmd=(curl -v -s)
  fi

  case "$1" in
    4) ${cmd[@]} -4 "$url" ;;
    6) ${cmd[@]} -6 "$url" ;;
    *) ${cmd[@]} "$url" ;;
  esac
}

function ping-default-route() {
  if >/dev/null declare -f -F default-route
  then die 1 'default-route function muse be defined'
  fi
  ping "$@" "$(default-route)"
}

(( $+commands[wg] )) && {
  function wg-pair() {
    local priv_key pub_key
    priv_key="$(wg genkey)"
    pub_key="$(echo "$priv_key" | wg pubkey)"

    if [[ $1 == '-f' ]]
    then
      echo "$priv_key" > key
      echo "$pub_key" > pub
    else
      echo 'private key:' "$priv_key"
      echo 'public key: ' "$pub_key"
    fi
  }
}
