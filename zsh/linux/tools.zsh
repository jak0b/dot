function default-route() { ip route | awk '/^default.*/{print $3; exit}'; }

function locip() { ip route get 1.1.1.1 | awk 'NR==1{print $7}'; }

function arch-remove-orphans() {
  if command &>/dev/null yay -V;
    then local pkgmgr=yay
  elif command &>/dev/null pacman -V;
    then local pkgmgr=pacman;
  else
    echoerr 'no package manager'
    return 1
  fi

  local orphan_packages=$($pkgmgr -Qtdq)
  if [ -n "$orphan_packages" ]; then
    $pkgmgr -Rs "$orphan_packages"
  else
    echoerr 'found no orphans'
    return 2
  fi
}

function findusb() {
  local vendor product
  if [ $# -lt 1 ]; then
    echo "Usage: `basename $0` {idVendor}{:|' '}{idProduct}"
    return 1
  elif [ $# -eq 1 ]; then
    if ! echo "$1" | grep ":" 1>/dev/null ; then
      echo invalid format
      return 2
    fi
    vendor=$(echo "$1" | cut -d":" -f1)
    product=$(echo "$1" | cut -d":" -f2)
  elif [ $# -eq 2 ]; then
    vendor="$1"
    product="$2"
  fi

  for dev in /sys/bus/usb/devices/*; do
    local vendor_path="${dev}/idVendor"
    local product_path="${dev}/idProduct"
    if [ -f "$vendor_path" ] && [ -f "$product_path" ]; then
      local vendor_content=$(<${vendor_path})
      local product_content=$(<${product_path})

      if [ "$vendor" = "$vendor_content" ] && \
         [ "$product" = "$product_content" ]; then
        echo "$dev"
        break
      fi
    fi
  done
}

function iwctl-reconnect() {
  local dev="${1:=wlan0}"
  local current_network=$(iwctl station "$dev" get-networks | grep '>' | cut -d' ' -f6)
  iwctl station "$dev" disconnect
  iwctl station "$dev" connect "$current_network"
}

function hrdwid() { sha384sum /etc/machine-id | awk '{print $1}'; }
