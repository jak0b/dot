function rand() {
  local length=${1:-64}
  local pass=$(tr -cd '0-9a-zA-Z!#$%&*+-=?@^_|' < /dev/urandom | fold -w"$length" | head -n1)
  echo $pass
}

function randa() {
  local length=${1:-64}
  local pass=$(tr -cd '0-9a-zA-Z' < /dev/urandom | fold -w$length | head -n1)
  echo $pass
}

function htmlEncode() {
    local s
    s=${1//&/&amp;}
    s=${s//</&lt;}
    s=${s//>/&gt;}
    s=${s//'"'/&quot;}
    printf -- %s "$s"
}
