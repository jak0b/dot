if [[ ! -f "$ZSH_CACHE_DIR/_helm" ]]; then
  helm completion zsh | tee "$ZSH_CACHE_DIR/_helm" >/dev/null
  source "$ZSH_CACHE_DIR/_helm"
else
  source "$ZSH_CACHE_DIR/_helm"
fi

alias hc="helm create"

alias hdepb="helm dependency build"
alias hdepl="helm dependency list"
alias hdepu="helm dependency update"

alias hga="helm get all"
alias hgh="helm get hooks"
alias hgm="helm get manifest"
alias hgn="helm get notes"
alias hgv="helm get values"

alias hh="helm history"

alias hi="helm install"
alias hidr="helm install --dry-run"

alias hl="helm lint"

alias hls="helm list"
alias hlsa="helm list --all-namespaces"

alias hp="helm package ."
alias hpb="helm package -d build ."

alias hpli="helm plugin install"
alias hplui="helm plugin uninstall"
alias hplu="helm plugin update"
alias hplls="helm plugin list"

alias hpll="helm pull"

alias hra="helm repo add"
alias hri="helm repo index"
alias hrls="helm repo list"
alias hrr="helm repo remove"
alias hru="helm repo update"

alias hrlb="helm rollback"

alias hsrh="helm search hub"
alias hsrr="helm search repo"

alias hsa="helm show all"
alias hsc="helm show chart"
alias hsr="helm show readme"
alias hsv="helm show values"

alias hs="helm status"

alias hdel="helm delete"

alias ht="helm template"
alias htv="ht | nvim -c 'set ft=yaml' -"

alias htt="helm test"

alias hui="helm uninstall"

alias hu="helm upgrade --install"
alias hudr="helm upgrade --dry-run"
