# sdefs
Steam Deck Emulation From Scratch

# Warning!!!
This is a personal passion project after getting frustrated with EmuDeck and RetroDeck either being opaque, overly complex, or blocking my ability to modify the configuration of emulators (namely RetroArch).  

This may eventually be 'stable' but until this Warning is removed - it's going to get a lot of, potentally breaking, updates

# About
This is an alternative to install and manage emulators, configs, and data rescoures on the Steam Deck using the applications from the native 'Discover' application on the Steam Deck.  

This should in theory be compatible with any other FlatPak Linux disto, but development will be talored to the Steam Deck.

# What it should do
- Install FlatPak versions of each emulator (exact list pending) from the SD flatpak CLI
  - Only use RetroArch cores if the FlatPak emulators don't play well with Gampads
- Link the imprtant data folders for each emulator/core to a common location (e.g. saves, screenshots, ect.)
- Install a default config file for the controls and semi-good visual settings
- Allow the user to change the configurations as they see fit, however they see fit
- Provide a 'config reset' option in case something get's changed that really messes up their experience

# Assumptions/Design Contraints
- Assume a standard 'EmulationStation-DE' rom folder structure
 - This is required to be able to 'guess' content directory names for RetroArch

# Known issues
- Right now assumes the rom folder is on an SD card (standard ES-DE location)

# Incomplete Things
- Does not install/modify config files to setup mappings yet (coming later)
- Does not check for/link BIOS files to their proper locations (coming later)
- Does not modify EmulationStation-DE default emulator commands to match installed emulators (research needed)

# Annoying Things: RetroArch
- SteamDeck's "gamepad" mode doesn't have dedicated input events for L/R 4 and 5 (at least not ones that RetroArch understands)
 - Workaround Mappings:
 - L4 = ;
 - L5 = '
 - R4 = ,
 - R5 = .
- Some games use 'Select' for the AmberELEC convetion of 'select' being a Hotkey-Enable causes gameplay problems
 - Workaround: L4 (;) is mapped to Hotkey enable where possible

# Annoying Things: DuckStation
- Doesn't have a 'hotkey enable' mode so all keys immediately do hotkey functions
- Workaround: Use the community controler bindings to enable a hotkey radial menu on the left mousepad

# Hotkey Setup: Retroarch
- Exit       : L4 + Start
- FF         : L4 + R2
- Save State : L4 + R1
- Load State : L4 + L1
- Screenshot : L4 + L2
- Menu       : L3 + R3 (Retroarch)

# Additoinal Setup: DuckStation
- When adding DuckStation to steam - edit the command to include '-bigpicture' to launch in Steamdeck compatable mode
