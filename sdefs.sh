#!/bin/bash
set -o nounset

function defaults() {
  export emudata="/run/media/mmcblk0p1/Emulation/data"
  export script_log="/tmp/$_script.log"
}

function safe_mkdir() {
  if [ ! -d "$1" ]; then
    echo "Creating Directory: '$1'"
    mkdir -p "$1"
  fi
}

function safe_mklnk() {
  if [ ! -L "$2" ]; then
    echo "Linking '$2' -> '$1'"
    ln -s "$1" "$2"
  fi
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

function check_bios() {
  case "$1" in
    'org.duckstation.DuckStation')
      local _biosdir="$HOME/.var/app/org.duckstation.DuckStation/config/duckstation/bios"
      for _file in scph5500.bin scph5501.bin scph5502.bin scph5503.bin scph7003.bin; do
        if [ -f "$_biosdir/$_file" ]; then
          echo "DuckStation BIOS File: $_file : Present"
        else
          echo "DuckStation BIOS File: $_file : Missing - Install with 'cp FILE $_biosdir/'"
        fi
      done
      ;;
  esac
}

function setup_emudata() {
  case "$1" in
    'org.duckstation.DuckStation')
      local _emudata="$emudata/duckstation"
      local _vardata="$HOME/.var/app/org.duckstation.DuckStation/config/duckstation/memcards"
      local _bios="$HOME/.var/app/org.duckstation.DuckStation/config/duckstation/bios"
      safe_mkdir "$_emudata"
      # DuckStation has 3 data directories to link
      safe_mklnk "$_vardata/memcards" "$_emudata/saves"
      safe_mklnk "$_vardata/screenshots" "$_emudata/screenshots"
      safe_mklnk "$_vardata/savestates" "$_emudata/savestates"      
      safe_mklnk "$_bios" "$_emudata/bios"
      echo "DuckStation: Emudata linked to: $_emudata"
      check_bios "$1"
    ;;

    'ca._0ldsk00l.Nestopia')
      local _emudata="$emudata/nestopia-ue"
      local _vardata="$HOME/.var/app/ca._0ldsk00l.Nestopia/data/nestopia"
      safe_mkdir "$_emudata"
      # Nestopia has 3 directories of interest we want to link-out
      for _dir in save screenshots state; do
        safe_mklnk "$_vardata/$_dir" "$_emudata/$_dir"
      done
      ;;

    'org.libretro.RetroArch')
      # There's several cores here - so set them all up
      # NOTE: This doesn't have to exist yet, we can still set up the symlinks now
      local _vardata="$HOME/.var/app/org.libretro.RetroArch/config/retroarch"
      # List of RetroArch cores to set up
      # In personal, opinionated testing FCEUmm gave better performance than Nestopia even
      # if Nestopia is more accurate
      for _enabled in FCEUmm; do
        case $_enabled in
          'Nestopia')
            # Nestopia
            local _emudata="$emudata/retroarch-nestopia"
            safe_mkdir "$_emudata"
            # Retroarch sorts saves by core name, but sreenshots by content-dir
            safe_mklnk "$_vardata/saves/Nestopia" "$_emudata/saves"
            safe_mklnk "$_vardata/screenshots/nes" "$_emudata/screenshots"
            #echo "Retroarch-Nestopia: Emudata linked to $_emudata"
          ;;
          'FCEUmm')
            local _emudata="$emudata/retroarch-fceumm"
            safe_mkdir "$_emudata"
            # Retroarch sorts saves by core name, but sreenshots by content-dir
            safe_mklnk "$_vardata/saves/FCEUmm" "$_emudata/saves"
            safe_mklnk "$_vardata/states/FCEUmm" "$_emudata/saves"
            safe_mklnk "$_vardata/screenshots/nes" "$_emudata/screenshots"
            echo "Retroarch-FCEUmm: Emudata linked to $_emudata"
          ;;
        esac
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
  #safe_mkdir "$emudata"
  # Nestopia-UE currently has no way to cleanly quit the emulator from fullscreen
  # OR to easily set up keybindings.  If someone can figiure out a simple way around
  # this I'm open to re-instituting it, but at this time the only gamepad-centric way
  # to use this emulator is though libretro
  #setup_flatpak 'Nestopia-UE' 'ca._0ldsk00l.Nestopia'

  # Despite all efforts, RetroArch still is one of the only ways to interact wtih an
  # some emulators in a fully gamepad-centric way.  
  setup_flatpak 'RetroArch' 'org.libretro.RetroArch'
  setup_flatpak 'DuckStation' 'org.duckstation.DuckStation'
}

main "$@"
