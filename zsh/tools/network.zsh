pubip() {
  local ip_version="${1:-64}"
  local rsp=$(curl -s "https://api${ip_version}.ipify.org")
  echo "$rsp"
}


