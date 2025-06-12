function idasen() {
  local server_url position

  server_url='idasen.jak0b.com'
  position="$1"
  [[ $position = "to" ]] && { shift; position="$1"; }

  if [[ -z $position ]]
  then die 'Position cannot be empty'
  fi

  curl "${server_url}/api/${position}"
}

function deskd() {
  local aim secret
  case "$1" in;
    left|right|both) aim=$1 ;;
    *) return 1 ;;
  esac
  curl "https://ha.jak0b.com/api/webhook/toggle-display-${aim}-$(hrdwid)"
}

