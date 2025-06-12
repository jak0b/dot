function default-route() { route -n get default | awk 'NR==4{print $2}'; }

function ping-default-route() { ping "$@" "$(default-route)"; }

function locip() { ifconfig en0 inet | awk 'NR==3 {print $2}'; }

function hrdwid() {
  system_profiler SPHardwareDataType \
    | grep -v 'System Firmware Version\|OS Loader Version' \
    | sha384
}
