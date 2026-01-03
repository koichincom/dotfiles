#!/usr/bin/env python3
import sys
import re
import argparse
import shutil
from pathlib import Path

# Add current directory to path to allow import if run from elsewhere
sys.path.append(str(Path(__file__).parent))
from format import format_layer


def format_keymap_file(
    filepath: str, backup: bool = False, dry_run: bool = False, gap: int = 5
) -> None:
    """
    Formats all LAYOUT blocks in the given keymap file.
    """
    path = Path(filepath)
    if not path.exists():
        print(f"Error: File not found: {filepath}", file=sys.stderr)
        sys.exit(1)

    try:
        content = path.read_text(encoding="utf-8")
    except Exception as e:
        print(f"Error reading file: {e}", file=sys.stderr)
        sys.exit(1)

    # Regex to find LAYOUT(...) blocks
    # Captures the content inside the parentheses
    # Handling nested parentheses is hard with regex, but QMK layouts usually don't have them in keycodes?
    # Actually functions like MO(1) or TD(X) use parens.
    # So a simple regex might fail.
    # We need to balance parentheses.

    # Let's verify if we need complex parsing.
    # QMK keycodes: KC_A, MO(1), LT(1, KC_A), etc.
    # So yes, we have nested parens.

    # We'll use a scanner approach to find LAYOUT blocks and extract content accurately.

    new_content = ""
    last_pos = 0
    formatted_count = 0

    # Find all "LAYOUT(" occurrences
    # We search iteratively

    search_start = 0
    while True:
        match = re.search(r"LAYOUT\s*\(", content[search_start:])
        if not match:
            new_content += content[last_pos:]
            break

        start_idx = search_start + match.start()
        content_start = search_start + match.end()

        # Append everything before this LAYOUT block
        new_content += content[last_pos:start_idx]

        # Find matching closing parenthesis
        balance = 1
        i = content_start
        while i < len(content) and balance > 0:
            if content[i] == "(":
                balance += 1
            elif content[i] == ")":
                balance -= 1
            i += 1

        if balance > 0:
            print(
                f"Warning: Unbalanced parentheses in LAYOUT starting at char {start_idx}",
                file=sys.stderr,
            )
            # Just keep original and move on
            new_content += content[
                start_idx:i
            ]  # This is technically broken but safe fallback
            last_pos = i
            search_start = i
            continue

        # Extract content (excluding the final closing paren)
        layout_content = content[content_start : i - 1]

        # Format it
        formatted_inner = format_layer(layout_content, gap)

        # Reconstruct the block
        # We want: LAYOUT(\n<formatted>\n  )
        # Note: format_layer returns just the lines.
        # We need to ensure we wrap it nicely.

        block = f"LAYOUT(\n{formatted_inner}\n  )"
        new_content += block

        last_pos = i
        search_start = i
        formatted_count += 1

    if formatted_count == 0:
        print("No LAYOUT blocks found.")
        return

    if dry_run:
        print("Dry run complete. Formatted content preview:")
        print(new_content)
        return

    if backup:
        backup_path = path.with_suffix(".c.bak")
        shutil.copy2(path, backup_path)
        print(f"Backup created: {backup_path}")

    path.write_text(new_content, encoding="utf-8")
    print(f"Successfully formatted {formatted_count} layers in {filepath}")


def main():
    parser = argparse.ArgumentParser(description="Format QMK keymap file.")
    parser.add_argument("file", help="Path to keymap.c file")
    parser.add_argument("--backup", action="store_true", help="Create backup file")
    parser.add_argument(
        "--dry-run", action="store_true", help="Show changes without modifying"
    )
    parser.add_argument(
        "--gap", type=int, default=5, help="Spaces between halves (default: 5)"
    )

    args = parser.parse_args()

    format_keymap_file(args.file, args.backup, args.dry_run, args.gap)


if __name__ == "__main__":
    main()
