function wg-pair() {
  local priv_key=$(wg genkey)
  local pub_key=$(echo "$priv_key" | wg pubkey)

  if [ "$1" = "-f" ]; then
    echo "$priv_key" > key
    echo "$pub_key" > pub
  else
    echo 'private key:' "$priv_key"
    echo 'public key: ' "$pub_key"
  fi
}
