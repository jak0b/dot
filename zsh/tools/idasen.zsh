function idasen() {
  local server_url='idasen.jak0b.com'

  local position="$1"
  if [ "$position" = "to" ]; then
    shift && position="$1"
  fi
  if [ -z "$position" ]; then
    echo 'Position cannot be empty'
    return 1
  fi

  curl "${server_url}/api/${position}"
}
