#!/bin/bash
set -o nounset

function defaults() {
  export emu_data="/run/media/mmcblk0p1/Emulation/data"
  export script_log="/tmp/$_script.log"
}

function mk_dirs() {
  echo "Creating emudata folder: '$emu_data'"
  mkdir -p "$emu_data"

}

function setup_flatpak() {
  local name="$1"
  local flat_id="$2"
  echo "Setting up: $name"

  # Check if the flatpak is installed or not
  flat_present="$(>/dev/null 2>&1 flatpak info "$flat_id"; echo $?)"
  if [ ! $flat_present = 0 ]; then
    # if not, install it
    echo "$Name: Installing..."
  fi

  # Re-check that the app was installed
  flat_present="$(>/dev/null 2>&1 flatpak info "$flat_id"; echo $?)"
  if [ $flat_present = 0 ]; then
    # Set up the emulation directory links
    setup_emudata "$flat_id"
  fi
}

function setup_emudata() {
  case "$1" in
    'ca._0ldsk00l.Nestopia')
      ln -s ~/.var/app/ca._0ldsk00l.Nestopia/data/nestopia/save "$emu_data/nestopia-ue"
      ;;
    *)
      echo "Internal Error: No support for flatpak name '$1' - Please open a GitIssue"
      ;;
  esac
}

function main() {
  export _script="$0"
  defaults
  mk_dirs
  setup_nestopia
}

main "$@"
