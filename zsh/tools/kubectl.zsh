CACHE_FILE="${ZSH_CACHE_DIR}/_kubectl"

if [[ ! -f "$CACHE_FILE" ]]
then
  command kubectl completion zsh > "$CACHE_FILE"
  source "$CACHE_FILE"
else
  source "$CACHE_FILE"
fi
unset CACHE_FILE

# This command is used a LOT both below and in daily life
alias k=kubectl

# Execute a kubectl command against all namespaces
alias kca='fn_kca(){ k "$@" --all-namespaces;  unset -f fn_kca; }; fn_kca'

alias kk='k kustomize'

# Apply a YML file
alias kaf='k apply -f'
alias kkaf='fn_kkaf(){ kk "$@" | kaf -; unset -f fn_kkaf }; fn_kkaf'

# Drop into an interactive terminal on a container
alias keti='k exec -t -i'

# General aliases
alias kdel='k delete'
alias kdelf='k delete -f'
alias kkdelf='fn_kkdelf(){ kk "$@" | kdelf -; unset -f fn_kkdelf }; fn_kkdelf'

# Pod management.
alias kgp='k get pods'
alias kgpa='k get pods --all-namespaces'
alias kgpw='kgp --watch'
alias kgpwide='kgp -o wide'
alias kep='k edit pods'
alias kdp='k describe pods'
alias kdelp='k delete pods'
alias kgpall='k get pods --all-namespaces -o wide'

# get pod by label: kgpl "app=myapp" -n myns
alias kgpl='kgp -l'

# get pod by namespace: kgpn kube-system"
alias kgpn='kgp -n'

# Service management.
alias kgs='k get svc'
alias kgsa='k get svc --all-namespaces'
alias kgsw='kgs --watch'
alias kgswide='kgs -o wide'
alias kes='k edit svc'
alias kds='k describe svc'
alias kdels='k delete svc'

# Ingress management
alias kgi='k get ingress'
alias kgia='k get ingress --all-namespaces'
alias kei='k edit ingress'
alias kdi='k describe ingress'
alias kdeli='k delete ingress'

# Namespace management
alias kgns='k get namespaces'
alias kens='k edit namespace'
alias kdns='k describe namespace'
alias kdelns='k delete namespace'

# ConfigMap management
alias kgcm='k get configmaps'
alias kgcma='k get configmaps --all-namespaces'
alias kecm='k edit configmap'
alias kdcm='k describe configmap'
alias kdelcm='k delete configmap'

# Secret management
alias kgsec='k get secret'
alias kgseca='k get secret --all-namespaces'
alias kdsec='k describe secret'
alias kdelsec='k delete secret'

# Deployment management.
alias kgd='k get deployment'
alias kgda='k get deployment --all-namespaces'
alias kgdw='kgd --watch'
alias kgdwide='kgd -o wide'
alias ked='k edit deployment'
alias kdd='k describe deployment'
alias kdeld='k delete deployment'
alias ksd='k scale deployment'
alias krsd='k rollout status deployment'

function kres(){
  k set env $@ REFRESHED_AT=$(date +%Y%m%d%H%M%S)
}

# Rollout management.
alias kgrs='k get replicaset'
alias kdrs='k describe replicaset'
alias kers='k edit replicaset'
alias krh='k rollout history'
alias kru='k rollout undo'

# Statefulset management.
alias kgss='k get statefulset'
alias kgssa='k get statefulset --all-namespaces'
alias kgssw='kgss --watch'
alias kgsswide='kgss -o wide'
alias kess='k edit statefulset'
alias kdss='k describe statefulset'
alias kdelss='k delete statefulset'
alias ksss='k scale statefulset'
alias krsss='k rollout status statefulset'

# Port forwarding
alias kpf="kubectl port-forward"

# Tools for accessing all information
alias kga='k get all'
alias kgaa='k get all --all-namespaces'

# Logs
alias kl='k logs'
alias kl1h='k logs --since 1h'
alias kl1m='k logs --since 1m'
alias kl1s='k logs --since 1s'
alias klf='k logs -f'
alias klf1h='k logs --since 1h -f'
alias klf1m='k logs --since 1m -f'
alias klf1s='k logs --since 1s -f'

# File copy
alias kcp='kubectl cp'

# Node Management
alias kgno='k get nodes'
alias keno='k edit node'
alias kdno='k describe node'
alias kdelno='k delete node'

# PVC management.
alias kgpvc='k get pvc'
alias kgpvca='k get pvc --all-namespaces'
alias kgpvcw='kgpvc --watch'
alias kepvc='k edit pvc'
alias kdpvc='k describe pvc'
alias kdelpvc='k delete pvc'

# Service account management.
alias kdsa="k describe sa"
alias kdelsa="k delete sa"

# DaemonSet management.
alias kgds='k get daemonset'
alias kgdsw='kgds --watch'
alias keds='k edit daemonset'
alias kdds='k describe daemonset'
alias kdelds='k delete daemonset'

# CronJob management.
alias kgcj='k get cronjob'
alias kecj='k edit cronjob'
alias kdcj='k describe cronjob'
alias kdelcj='k delete cronjob'

# Job management.
alias kgj='k get job'
alias kej='k edit job'
alias kdj='k describe job'
alias kdelj='k delete job'


function kc() {
  local selected_ctx=$(kubectl config get-contexts | fzf --header-lines=1 | tail -c +2 | cut -d' ' -f 10)
  kubectl config set current-context "$selected_ctx" &>/dev/null
}

function kn() {
  local selected_ns=$(kubectl get ns | fzf --header-lines=1 | cut -d' ' -f 1)
  kubectl config set-context --current --namespace "$selected_ns" &>/dev/null
}

function kcc() {
  kubectl config get-contexts | awk '/\*/{print $2; exit}'
}

function knc() {
  kubectl config get-contexts | awk '/\*/{print $5; exit}'
}

alias kg="k get"
alias kd="k describe"
alias ke="k edit"
alias kdel="k delete"
alias kt="k top"

alias kas="k autoscale"
alias kasd="kas deployment"
alias kasrs="kas replicaset"
alias kasrc="kas replicationcontroller"

alias kcns="k create namespace"
alias kdelns="k delete namespace"

alias ktp="k top pods"
alias ktpa="k top pods --all-namespaces"
alias ktn="k top nodes"

alias kgn="k get nodes"
alias ken="k edit nodes"
alias kdn="k describe nodes"
alias kdeln="k delete nodes"

alias kgpv="k get persistentvolumes"
alias kepv="k edit persistentvolumes"
alias kdpv="k describe persistentvolume"
alias kdelpv="k delete persistentvolume"

alias kgcer="k get certificates.cert-manager.io"
alias kgcera="k get certificates.cert-manager.io --all-namespaces"
alias kecer="k edit certificates.cert-manager.io"
alias kdcer="k describe certificates.cert-manager.io"
alias kdelcer="k delete certificates.cert-manager.io"

alias kgcerrq="k get certificaterequests.cert-manager.io"
alias kgcerrqa="k get certificaterequests.cert-manager.io --all-namespaces"
alias kecerrq="k edit certificaterequests.cert-manager.io"
alias kdcerrq="k describe certificaterequests.cert-manager.io"
alias kdelcerrq="k delete certificaterequests.cert-manager.io"

alias kgj="k get jobs.batch"
alias kgja="k get jobs.batch --all-namespaces"
alias kej="k edit jobs.batch"
alias kdj="k describe jobs.batch"
alias kdelj="k delete jobs.batch"

alias kgnp="k get networkpolicies.networking.k8s.io"
alias kgnpa="k get networkpolicies.networking.k8s.io --all-namespaces"
alias kenp="k edit networkpolicies.networking.k8s.io"
alias kdnp="k describe networkpolicies.networking.k8s.io"
alias kdelnp="k delete networkpolicies.networking.k8s.io"

alias kgvatt="k get volumeattachments.storage.k8s.io"
alias kgvatta="k get volumeattachments.storage.k8s.io --all-namespaces"
alias kevatt="k edit volumeattachments.storage.k8s.io"

# Scale deployment
alias ksd0="ksd --replicas 0"
alias ksd1="ksd --replicas 1"
alias ksd2="ksd --replicas 2"
alias ksd3="ksd --replicas 3"
alias ksd4="ksd --replicas 4"
alias ksd5="ksd --replicas 5"
alias ksd6="ksd --replicas 6"
alias ksd7="ksd --replicas 7"
alias ksd8="ksd --replicas 8"
alias ksd9="ksd --replicas 9"

function ksdn {
  ksd --replicas $1
}

# Scale stateful set
alias ksss0="ksss --replicas 0"
alias ksss1="ksss --replicas 1"
alias ksss2="ksss --replicas 2"
alias ksss3="ksss --replicas 3"
alias ksss4="ksss --replicas 4"
alias ksss5="ksss --replicas 5"
alias ksss6="ksss --replicas 6"
alias ksss7="ksss --replicas 7"
alias ksss8="ksss --replicas 8"
alias ksss9="ksss --replicas 9"

function ksssn {
  ksss --replicas $1
}

function kdockersec {
  local secret_name docker_config from_file_arg
  local secret_type_arg='--type=kubernetes.io/dockerconfigjson'

  if [ -z "$1" ]; then
    echo no secret name
    return 1
  else
    secret_name="$1"
  fi

  if [ -z "$2" ]; then
    docker_config="$HOME/.docker/config.json"
  else
    docker_config="$2"
  fi

  if [ ! -f $docker_config ]; then
    echo docker config does not exist
    return 1
  fi

  from_file_arg="--from-file=.dockerconfigjson=$docker_config"

  k create secret generic "$secret_name" "$from_file_arg" "$secret_type_arg" 
}

alias kdelpf="kdelp --field-selector=status.phase==Failed"
alias kdelpfa="kdelpf --all-namespaces"



