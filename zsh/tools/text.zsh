function rand() {
  local length pass

  length=${1:-64}
  pass=$(LC_ALL=C tr -cd '0-9a-zA-Z!#$%&*+-=?@^_|' < /dev/urandom | fold -w"$length" | head -n1)
  echo $pass
}

function randa() {
  local length pass

  length=${1:-64}
  pass=$(LC_ALL=C tr -cd '0-9a-zA-Z' < /dev/urandom | fold -w$length | head -n1)
  echo $pass
}

function encode-html() {
  local s="$1"; if [ -z "$s" ]; then read s; fi

  s=${s//&/&amp;}
  s=${s//</&lt;}
  s=${s//>/&gt;}
  s=${s//'"'/&quot;}

  printf -- %s "$s"
}

function pickchars() {
  local first_line
  read -r first_line

  for (( i = 1; i <= ${#first_line}; i++ )); do
    for arg in "$@"; do
      if (( i == arg )); then
        echo "$i ${first_line[i]}"
      fi
    done
  done
}

function encode-url() {
  local s="$1"; if [ -z "$s" ]; then read s; fi

  local slen=${#s}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<slen ; pos++ )); do
     c=${s:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
    printf -- %s "$encoded"
}


(( $+commands[ollama] )) && {
  function git-message() {
    local model diff message

    model="$1"
    if [[ -z $model ]]
    then model='llama3.2:3b'
    fi

    diff="$(2>/dev/null git diff HEAD)"
    if [[ -z $diff ]]
    then return
    fi

    message=$(printf '%s\n```\n%s\n```\n%s\n%s\n' \
    'Write a git message (using Semantic Commit Messages) from the following diff' \
    "$diff" 'Show only that message (without any quotations)')

    ollama run "$model" <<< "$message"
  }
}

(( $+commands[bc] )) && {
  function calc-tax() {
    if [[ $# -lt 2 ]]; then return 1; fi
    local ammount="$(bc <<< "${1} * 100")" rate="$2"

    printf "Without tax: %s\n" $(bc <<< "scale=2;( ${ammount} * 100 / ( ${rate} + 100 )) / 100")
    printf "Tax: %s\n" $(bc <<< "scale=2;( ${ammount} * ${rate} / ( ${rate} + 100 )) / 100")
  }

  function calc-tax-23() { calc-tax "$@" 23; }
  function calc-tax-19() { calc-tax "$@" 19; }
}
