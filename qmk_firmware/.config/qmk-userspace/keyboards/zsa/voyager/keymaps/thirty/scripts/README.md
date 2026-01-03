# Formatting Scripts

Helper scripts to maintain column alignment in `keymap.c`.

## Usage

These commands assume you are running from the `thirty/` directory (where `keymap.c` resides).

### Format Keymap File
Formats all layers in the keymap file in-place.

```bash
python3 scripts/run_format.py keymap.c
```

### Format Single Layer (CLI)
Formats a raw layer string (stdin) and outputs to stdout.

```bash
echo "XXX, KC_Q, ..." | python3 scripts/format.py
```

## Files
- `run_format.py`: Main tool. Orchestrates file reading, formatting, and writing.
- `format.py`: Core logic. Can be imported or used as a CLI filter.
