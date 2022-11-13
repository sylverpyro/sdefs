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
    echo "$name: Setting up emudata folder"
    setup_emudata "$flat_id"
  fi
}

function setup_emudata() {
  case "$1" in
    'ca._0ldsk00l.Nestopia')
      # Nestopia has 3 directories of interest we want to link-out
      for _dir in save screenshots state; do
        if [ ! -L "$emu_data/nestopia-ue/$_dir" ]; then
          ln -s "~/.var/app/ca._0ldsk00l.Nestopia/data/nestopia/$_dir" "$emu_data/nestopia-ue"
        fi
      done
      ;;

    *)
      # Unrecognized flatpak IDs are a bug - please report
      echo "Internal Error: No support for flatpak name '$1' - Please open a GitIssue"
      ;;
  esac
}

function main() {
  export _script="$0"
  defaults
  mk_dirs
  setup_flatpak 'Nestopia-UE' 'ca._0ldsk00l.Nestopia'
}

main "$@"
