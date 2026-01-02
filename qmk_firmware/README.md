# QMK External Userspace

My keyboard configurations using QMK's [External Userspace](https://docs.qmk.fm/newbs_external_userspace) feature.

This separates my personal keymaps from the main QMK Firmware repository, making them easy to version control and portable across machines.

## Prerequisites

Install QMK Firmware (required for building):

```bash
git clone https://github.com/qmk/qmk_firmware.git ~/qmk_firmware
cd ~/qmk_firmware
qmk setup
```

## Setup

After stowing this package, you **must** configure QMK CLI to use the external userspace:

```bash
# 1. Stow this package (from main dotfiles repo)
cd ~/.dotfiles
stow qmk_firmware

# 2. Configure QMK CLI (REQUIRED - run once per machine)
qmk config user.overlay_dir="$HOME/.config/qmk-userspace"
```

### Why is step 2 needed?

The `qmk config` command creates `~/.config/qmk/qmk.ini` which tells QMK CLI where to find your keymaps. This file contains machine-specific paths (e.g., `/home/username/`) and is not included in dotfiles for privacy/portability.

## Usage

### Compile Firmware

```bash
qmk compile -kb zsa/voyager -km thirty
```

### Flash to Keyboard

```bash
qmk flash -kb zsa/voyager -km thirty
```

### Compile All Userspace Targets

```bash
qmk userspace-compile
```

## Keymaps

- `keyboards/zsa/voyager/keymaps/thirty/` - My ZSA Voyager layout

## Structure

```
~/.config/qmk-userspace/           # Symlinked by stow
├── keyboards/                     # Keyboard-specific keymaps
│   └── zsa/voyager/keymaps/thirty/
│       ├── keymap.c
│       ├── config.h
│       └── rules.mk
└── qmk.json                       # Build targets
```

## How It Works

QMK's External Userspace feature allows storing keymaps outside the main firmware repository:

1. **QMK Firmware** (`~/qmk_firmware/`) - Build system and source code (not version controlled by you)
2. **External Userspace** (`~/.config/qmk-userspace/`) - Your personal keymaps (version controlled via dotfiles)
3. **QMK CLI Config** (`~/.config/qmk/qmk.ini`) - Points QMK to your userspace (created by manual command)

When you build, QMK overlays your userspace on top of the firmware repository.

## References

- [QMK External Userspace Documentation](https://docs.qmk.fm/newbs_external_userspace)
- [QMK CLI Configuration](https://docs.qmk.fm/cli_configuration)
