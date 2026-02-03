bash#!/usr/bin/env bash
# vim: ai ts=2 sw=2 et sts=2 ft=sh
# tasi-zia - Toggle Zscaler on/off
#
# Usage:
#   ./tasi-zia stop   # Disable and kill Zscaler
#   ./tasi-zia start  # Enable and restart Zscaler
#   ./tasi-zia        # Check status only

set -o errtrace
set -o nounset
set -o pipefail
shopt -s nocaseglob
shopt -s nullglob
IFS=$' '

# Globals
export Z_APPNAME="Zscaler"
export Z_PLUGINS="ZDP"
export Z_APP="/Applications/Zscaler/Zscaler.app"
export Z_BIN="${Z_APP}/Contents/MacOS/Zscaler"
export Z_TNL="${Z_APP}/Contents/PlugIns/ZscalerTunnel"
export Z_SRV="${Z_APP}/Contents/PlugIns/ZscalerService"

stop() {
  echo -e "--- 🔇 Disabling Zscaler executables..."
  sudo chmod -x "${Z_BIN}" 2>/dev/null
  sudo chmod -x "${Z_TNL}" 2>/dev/null
  sudo chmod -x "${Z_SRV}" 2>/dev/null
  
  echo -e "--- 💀 Killing Zscaler processes..."
  sudo lsof -nP -t -c "/${Z_APPNAME}|${Z_PLUGINS}/i" 2>/dev/null | xargs -I{} sudo kill -9 {} 2>/dev/null
  sudo launchctl list 2>/dev/null | grep -i -e "${Z_APPNAME}" -e "${Z_PLUGINS}" | cut -f 3 | xargs -I{} sudo launchctl bootout "system/{}" 2>/dev/null
  launchctl list 2>/dev/null | grep -i -e "${Z_APPNAME}" -e "${Z_PLUGINS}" | cut -f 3 | xargs -I{} launchctl bootout "gui/$(id -u)/{}" 2>/dev/null
  killall "${Z_APPNAME}" 2>/dev/null || true
  
  echo -e "--- ✅ Zscaler disabled."
}

start() {
  echo -e "--- 🔊 Enabling Zscaler executables..."
  sudo chmod +x "${Z_BIN}" 2>/dev/null
  sudo chmod +x "${Z_TNL}" 2>/dev/null
  sudo chmod +x "${Z_SRV}" 2>/dev/null
  
  echo -e "--- 🚀 Starting Zscaler..."
  killall "${Z_APPNAME}" 2>/dev/null || true
  open -a "${Z_APP}" -g
  
  echo -e "--- ✅ Zscaler enabled."
  echo -e "--- ⚠️  Reboot recommended for full restart."
}

check() {
  echo -e "--- 📡 Network connections:"
  sudo lsof +c0 -Pi -a -c "/${Z_APPNAME}/i" 2>/dev/null || echo "  None"
  
  echo -e "\n--- 🔄 Running processes:"
  sudo lsof -nP -t -c "/${Z_APPNAME}|${Z_PLUGINS}/i" 2>/dev/null | xargs -n1 -I{} ps -p {} -o pid=,command= 2>/dev/null || echo "  None"
  
  echo -e "\n--- 📦 Executable status:"
  for bin in "${Z_BIN}" "${Z_TNL}" "${Z_SRV}"; do
    if [[ -x "${bin}" ]]; then
      echo "  ✅ ENABLED:  $(basename ${bin})"
    else
      echo "  🔇 DISABLED: $(basename ${bin})"
    fi
  done
  echo ""
}

main() {
  case "${1:-check}" in
    stop)  check; stop; check ;;
    start) start; check ;;
    check) check ;;
    *)
      echo "Usage: tasi-zia [stop|start|check]"
      echo "  stop  - Disable and kill Zscaler"
      echo "  start - Enable and restart Zscaler"
      echo "  check - Show current status (default)"
      exit 1
      ;;
  esac
}

main "$@"
