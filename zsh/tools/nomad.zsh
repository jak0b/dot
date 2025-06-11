alias n=nomad

alias nj='n job'
alias njr='nj run'

alias nv='n volume'

function nn() {
  local selected config
  config="${HOME}/.local/share/nomad/config.json"

  if [[ -n $1 ]]
  then
    selected="$1"
  else
    selected="$(jq -r '.clusters | keys[]' < "$config" | fzf --header 'Select Nomad cluster:')"
  fi

  if [[ -n "$selected" ]]
  then 
    export NOMAD_ADDR="$(jq -r ".clusters[\"$selected\"].addr" < "$config")" && \
           echo "$NOMAD_ADDR" > "${HOME}/.local/share/nomad/.env/NOMAD_ADDR"

    export NOMAD_TOKEN="$(jq -r ".clusters[\"$selected\"].token" < "$config")" && \
           echo "$NOMAD_TOKEN" > "${HOME}/.local/share/nomad/.env/NOMAD_TOKEN"
  fi
}

function nns() {
  local selected

  if [[ -n $1 ]]
  then
    selected="$1"
  else
    selected="$(nomad namespace list | fzf --header-lines=1 | awk '{print $1}')"
  fi

  if [[ -n "$selected" ]]
  then 
    export NOMAD_NAMESPACE="$selected" && \
           echo "$NOMAD_NAMESPACE" > "${HOME}/.local/share/nomad/.env/NOMAD_NAMESPACE"
  fi
}

function nnsa() {
  export NOMAD_NAMESPACE='*' && \
         echo "$NOMAD_NAMESPACE" > "${HOME}/.local/share/nomad/.env/NOMAD_NAMESPACE"
}

function nomad-load() {
  if [ ! -d "${HOME}/.local/share/nomad/.env" ]; then
    mkdir -p "${HOME}/.local/share/nomad/.env"
  fi

  if [ -f "${HOME}/.local/share/nomad/.env/NOMAD_ADDR" ]; then
    export NOMAD_ADDR="$(< "${HOME}/.local/share/nomad/.env/NOMAD_ADDR")"
  fi

  if [ -f "${HOME}/.local/share/nomad/.env/NOMAD_TOKEN" ]; then
    export NOMAD_TOKEN="$(< "${HOME}/.local/share/nomad/.env/NOMAD_TOKEN")"
  fi

  if [ -f "${HOME}/.local/share/nomad/.env/NOMAD_NAMESPACE" ]; then
    export NOMAD_NAMESPACE="$(< "${HOME}/.local/share/nomad/.env/NOMAD_NAMESPACE")"
  fi

} && nomad-load && unset -f nomad-load
