function desk() {
  local position="$1"

  local server_host='10.96.2.9'
  local server_port='8080'

  test -n "$position" && \
  idasen-controller \
    --forward \
    --server-address "$server_host" \
    --server_port "$server_port" \
    --move-to "$position"
}
