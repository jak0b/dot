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

function __desk_helper() {
  local aim secret
  case "$1" in;
    left|right|both) aim=$1 ;;
    *) return 1 ;;
  esac
  curl "https://ha.jak0b.com/api/webhook/toggle-display-${aim}-$(hrdwid)"
} && {
  alias both='__desk_helper both'
  alias left='__desk_helper left'
  alias right='__desk_helper right'
}

