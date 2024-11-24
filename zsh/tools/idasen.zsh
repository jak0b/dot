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
