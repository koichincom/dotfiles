#!/usr/bin/env python3
import sys
import re
import argparse


def format_layer(layout_content: str, left_right_gap: int = 5) -> str:
    """
    Formats a single LAYOUT content string according to the specific alignment rules.

    Args:
        layout_content: The raw content inside LAYOUT(...)
        left_right_gap: Number of spaces between left and right halves (column 6 and 7)

    Returns:
        Formatted string ready to be placed inside LAYOUT()
    """
    # 1. Parse keycodes
    # Remove comments and normalize whitespace
    # We want to extract individual keycodes.
    # Keycodes are separated by commas.

    # First, strip whitespace from ends
    content = layout_content.strip()

    # Check if wrapped in LAYOUT(...), useful if AI pastes the whole block
    layout_match = re.search(r"LAYOUT\s*\((.*)\)", content, re.DOTALL)
    if layout_match:
        content = layout_match.group(1).strip()

    # Split by comma to get keycodes
    # We need to be careful not to split inside a keycode if that's possible (unlikely in QMK basic keycodes)
    # But we should handle whitespace around keycodes

    raw_keycodes = [k.strip() for k in content.split(",") if k.strip()]

    # Validate count
    total_keys = len(raw_keycodes)
    # Expected: 4 rows of 12 keys + 4 thumb keys = 48 + 4 = 52 keys
    # Or generically: (Rows * 12) + 4

    if total_keys < 16:  # Minimum reasonable keys
        # If we can't determine structure, just return original cleaned up
        return content

    # Detect structure
    # We assume standard structure: 12 columns for main rows
    cols_main = 12
    cols_thumb = 4  # 2 left, 2 right

    # Calculate number of main rows
    # main_keys = total_keys - cols_thumb
    # num_main_rows = main_keys / cols_main

    # However, sometimes layouts might vary.
    # The requirement is specific to the "thirty" keymap style
    # which implies 12 columns for main rows.

    main_keys = raw_keycodes[:-4]
    thumb_keys = raw_keycodes[-4:]

    if len(main_keys) % cols_main != 0:
        # Fallback if structure doesn't match expected 12-column layout
        # Just wrap nicely? For now, let's assume valid input for this specific keymap.
        # But to be safe, let's proceed with best effort.
        pass

    num_main_rows = len(main_keys) // cols_main

    # Organize into grid
    grid = []
    for r in range(num_main_rows):
        row_keys = main_keys[r * cols_main : (r + 1) * cols_main]
        grid.append(row_keys)

    # Calculate column widths
    # 12 columns
    col_widths = [0] * cols_main
    for r in range(num_main_rows):
        for c in range(cols_main):
            # length of keycode string
            length = len(grid[r][c])
            if length > col_widths[c]:
                col_widths[c] = length

    # Format main rows
    lines = []

    for r in range(num_main_rows):
        line_parts = []
        for c in range(cols_main):
            key = grid[r][c]
            width = col_widths[c]

            # Left align and pad
            # We need to add the comma to the width calc?
            # The rule says: "Pad with spaces to reach the column width. Add comma at the end of the column."
            # So the visual width is determined by the longest key.
            # Then we add spaces so that (key + spaces) == width
            # Then we add comma.

            padded_key = key.ljust(width)
            segment = f"{padded_key},"

            line_parts.append(segment)

        # Join with spaces
        # Rule: 5 spaces between col 6 (index 5) and col 7 (index 6)
        # 1 space between others

        # We can construct the line manually
        line_str = "    "  # Indentation

        for c in range(cols_main):
            line_str += line_parts[c]

            # Add separator
            if c == 5:  # After column 6 (left hand end)
                line_str += " " * left_right_gap
            elif c == 11:  # Last column
                # No space at end of line
                pass
            else:
                line_str += " "

        lines.append(line_str)

    # Format thumb row
    # Left thumb keys: raw_keycodes[-4], raw_keycodes[-3] (KC_BSPC, KC_SPC)
    # Right thumb keys: raw_keycodes[-2], raw_keycodes[-1] (KC_TAB, KC_ENT)

    left_thumb = thumb_keys[:2]
    right_thumb = thumb_keys[2:]

    # Calculate indent for left thumb
    # Left thumb last key (plus comma) should end where column 6 (plus comma) ends

    # Let's calculate the position of the end of column 6
    # It is sum(col_widths[0..5]) + 5 (commas) + 5 (spaces between cols)
    # Wait, simple math:
    # Each column c takes: col_widths[c] + 1 (comma) + 1 (space)
    # Except col 5 (6th col) has no following space in the "left block", but followed by GAP

    # Let's just measure the length of the first half of a formatted main row line
    # To be precise, we want alignment with the text.

    # Construct a dummy left half line to measure width
    dummy_left_parts = []
    for c in range(6):
        dummy_left_parts.append(" " * col_widths[c] + ",")

    # Join with 1 space
    dummy_left_str = " ".join(dummy_left_parts)
    target_left_end = len(dummy_left_str)

    # Construct left thumb string: "KC_BSPC, KC_SPC,"
    # Note: The last thumb key ALSO has a comma in this specific file format,
    # EXCEPT if it's the very last key of the layout?
    # In the example: "KC_BSPC, KC_SPC,     KC_TAB, KC_ENT"
    # Wait, check the example again.
    # "KC_BSPC, KC_SPC,     KC_TAB, KC_ENT" -> No comma at very end?
    # "KC_BSPC, KC_SPC," -> Yes comma after SPC.

    left_thumb_str = f"{left_thumb[0]}, {left_thumb[1]},"

    # Calculate needed padding
    padding_needed = target_left_end - len(left_thumb_str)

    # If padding is negative, it means thumb row is wider than columns.
    # In that case, we can't align to end without pushing out.
    # But usually thumb keys are few.

    if padding_needed < 0:
        padding_needed = 0  # Should not happen with standard keys

    indent = " " * padding_needed

    # Right thumb
    # Starts where col 7 starts.
    # Col 7 starts after the GAP.
    # So we just need to add the GAP.

    right_thumb_str = f"{right_thumb[0]}, {right_thumb[1]}"

    thumb_line = (
        "    " + indent + left_thumb_str + (" " * left_right_gap) + right_thumb_str
    )

    lines.append(thumb_line)

    # Join all lines
    return "\n".join(lines)


def main():
    parser = argparse.ArgumentParser(description="Format QMK keymap LAYOUT content.")
    parser.add_argument(
        "--gap",
        type=int,
        default=5,
        help="Spaces between left and right halves (default: 5)",
    )
    args = parser.parse_args()

    # Read from stdin
    content = sys.stdin.read()

    if not content.strip():
        # No input
        return

    try:
        formatted = format_layer(content, args.gap)
        print(formatted)
    except Exception as e:
        sys.stderr.write(f"Error formatting: {e}\n")
        sys.exit(1)


if __name__ == "__main__":
    main()
