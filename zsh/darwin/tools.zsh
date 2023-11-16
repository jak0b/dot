function default_route() {
  route -n get default | awk 'NR==4{print $2}'
}

function ping-default-route() {
  ping "$@" "$(default_route)"
}
