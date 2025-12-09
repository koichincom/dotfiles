# Winbar Redesign Plan

## Overview

Redesign the Neovim winbar for improved UX based on attention-frequency consumption patterns rather than semantic grouping.

### Design Philosophy

- **Show only when abnormal**: Flags appear only when something deviates from the expected state
- **Color as indicator**: Modified files use red highlighting instead of `+` suffix
- **Left-right split layout**: Primary info (filename, diagnostics) on left; context (cwd, branch, flags) on right
- **Minimal but functional**: Every element earns its place

---

## Current vs. Proposed Layout

### Current Layout

```
| [cwd]:[branch] | %= [path]/[filename+] [encode] [diagnostics] %= | [copilot] [wrap] [auto_write] |
|     LEFT       |                    CENTER                        |            RIGHT              |
```

### Proposed Layout

```
| [path/filename] [E:N] [W:N] |                    | [cwd:branch] [flags] |
|          LEFT               |       (empty)      |        RIGHT         |
```

**Examples:**

Normal state (no errors, everything enabled):
```
lua/plugins/blink.lua                                            nvim-dev:main
```

With diagnostics:
```
lua/plugins/blink.lua E:2 W:1                                    nvim-dev:main
```

With diagnostics and abnormal flags:
```
lua/plugins/blink.lua E:2 W:1                    nvim-dev:main copilot:off wrap:on
```

Modified file (filename turns red, no `+`):
```
lua/plugins/blink.lua E:2 W:1                                    nvim-dev:main
^^^^^^^^^^^^^^^^^^^^ (red color indicates modified)
```

---

## Component Specification

### Left Group (Primary Focus)

| Component | Visibility | Highlight Group | Notes |
|-----------|------------|-----------------|-------|
| `path/` | Always (if not empty) | `WinBar` (dimmed) | Relative path to file |
| `filename` | Always | `WinBarFileName` | Prominent |
| `filename` (modified) | When `vim.bo.modified` | `WinBarFileNameModified` (red) | No `+` suffix |
| `E:N` | Only if errors > 0 | `WinBarAlertRed` | Error count |
| `W:N` | Only if warnings > 0 | `WinBarAlertYellow` (new) | Warning count |

### Right Group (Context + Flags)

| Component | Visibility | Highlight Group | Notes |
|-----------|------------|-----------------|-------|
| `cwd` | Always | `WinBar` (dimmed) | Workspace directory name |
| `:` | Always (if both cwd and branch exist) | `WinBar` | Separator |
| `branch` | Always (if in git repo) | `WinBar` | Git branch name |
| `copilot:off` | Only if Copilot disabled | `WinBarAlertRed` | Verbose label |
| `wrap:on` | Only if wrap enabled | `WinBarAlertRed` | Verbose label |
| `save:off` | Only if autowrite disabled | `WinBarAlertRed` | Verbose label |
| `save:partial` | Only if autowrite partial | `WinBarAlertRed` | Verbose label |
| `encode:X` | Only if non-UTF-8 | `WinBarAlertRed` | e.g., `encode:latin1` |

---

## File Changes

### 1. `lua/modules/winbar/main.lua`

**Changes:**

1. **Restructure `render()` function** for left-right layout
   - Remove center alignment (`%=` in middle)
   - Left group: path, filename, diagnostics
   - Right group: cwd:branch, flags

2. **Update `components_map`**
   - Change `diagnostics` state from `string` to `{ errors = 0, warnings = 0 }`
   - Move `encode` to right-side flags group

3. **Remove `+` from filename rendering**
   - Currently: `cm.file_path_name.state.name .. (cm.file_mod.state and "+" or "")`
   - Change to: `cm.file_path_name.state.name`

4. **Add `WinBarAlertYellow` highlight for warnings**

5. **Update right group rendering**
   - Include `encode` as a flag
   - Use verbose labels for all flags

**Proposed `render()` structure:**

```lua
function M.render()
    if vim.bo.buftype ~= "" and vim.bo.filetype ~= "oil" then
        return
    end
    local cm = components_map

    -- Left group: path/filename + diagnostics
    local diagnostics_parts = {}
    if cm.diagnostics.state.errors > 0 then
        table.insert(diagnostics_parts, "%#WinBarAlertRed#E:" .. cm.diagnostics.state.errors)
    end
    if cm.diagnostics.state.warnings > 0 then
        table.insert(diagnostics_parts, "%#WinBarAlertYellow#W:" .. cm.diagnostics.state.warnings)
    end
    local diagnostics_str = join(" ", diagnostics_parts)

    local left_group = table.concat({
        "%#WinBar#",
        " ",
        cm.file_path_name.state.path,
        (cm.file_path_name.state.path ~= "" and cm.file_path_name.state.name ~= "") and "/" or "",
        cm.file_mod.state and "%#WinBarFileNameModified#" or "%#WinBarFileName#",
        cm.file_path_name.state.name,
        diagnostics_str ~= "" and " " or "",
        diagnostics_str,
    })

    -- Right group: cwd:branch + flags
    local context = table.concat({
        cm.cwd.state,
        (cm.cwd.state ~= "" and cm.git_branch.state ~= "") and ":" or "",
        cm.git_branch.state,
    })

    local flags = join(" ", {
        render_alert_component(cm.copilot.state),
        render_alert_component(cm.wrap.state),
        render_alert_component(cm.auto_write.state),
        render_alert_component(cm.encode.state),
    })

    local right_group = join(" ", { context, flags })

    local winbar = table.concat({
        left_group,
        "%=",
        "%#WinBar#",
        right_group,
        right_group ~= "" and " " or "",
    })
    vim.wo.winbar = winbar
end
```

---

### 2. `lua/modules/winbar/components/file.lua`

**Changes:**

1. **Update `get_diagnostics()` to return errors AND warnings**

```lua
function M.get_diagnostics()
    if vim.bo.buftype ~= "" then
        return { errors = 0, warnings = 0 }
    end

    local errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local warnings = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

    return { errors = #errors, warnings = #warnings }
end
```

2. **Remove `get_encode()` function** (moving to editor.lua as a flag)

---

### 3. `lua/modules/winbar/components/editor.lua`

**Changes:**

1. **Update `get_copilot()` to use verbose label**

```lua
function M.get_copilot(is_enable)
    if is_enable then
        return { text = "", is_alert = false }
    else
        return { text = "copilot:off", is_alert = true }
    end
end
```

2. **Update `get_wrap()` to use verbose label**

```lua
function M.get_wrap(is_enable)
    if is_enable then
        return { text = "wrap:on", is_alert = true }
    else
        return { text = "", is_alert = false }
    end
end
```

3. **Update `get_auto_write()` to use verbose labels**

```lua
function M.get_auto_write(state)
    if state == "true" then
        return { text = "", is_alert = false }
    elseif state == "partial" then
        return { text = "save:partial", is_alert = true }
    else
        return { text = "save:off", is_alert = true }
    end
end
```

4. **Add `get_encode()` function** (moved from file.lua, as flag)

```lua
function M.get_encode()
    if vim.bo.buftype ~= "" then
        return { text = "", is_alert = false }
    end
    local encode = (vim.bo.fileencoding or ""):lower()
    if encode ~= "utf-8" and encode ~= "" then
        return { text = "encode:" .. encode, is_alert = true }
    else
        return { text = "", is_alert = false }
    end
end
```

---

### 4. `lua/modules/winbar/main.lua` (components_map update)

**Changes to `components_map`:**

```lua
local components_map = {
    cwd = {
        state = "",
        getter = workspace.get_cwd,
    },
    diagnostics = {
        state = { errors = 0, warnings = 0 },  -- CHANGED: was string
        getter = file.get_diagnostics,
    },
    git_branch = {
        state = "",
        getter = workspace.get_branch,
    },
    file_path_name = {
        state = {
            path = "",
            name = "",
        },
        getter = file.get_path_name,
    },
    encode = {
        state = { text = "", is_alert = false },  -- CHANGED: was string, now alert component
        getter = editor.get_encode,  -- CHANGED: moved from file to editor
    },
    file_mod = {
        state = false,
        getter = file.get_file_mod,
    },
    wrap = {
        state = { text = "", is_alert = false },
        getter = editor.get_wrap,
    },
    copilot = {
        state = { text = "", is_alert = false },
        getter = editor.get_copilot,
    },
    auto_write = {
        state = { text = "", is_alert = false },
        getter = editor.get_auto_write,
    },
}
```

---

### 5. `lua/modules/highlight/preset.lua`

**Two changes needed:**

#### A. Fix Light Mode Filename Emphasis

Current issue: `WinBar` (path) and `WinBarFileName` (filename) have similar colors in light mode:
- Path: `colors.light.basics.fg` (#1F2328)
- Filename: `colors.light.gray[7]` (#424a53)

Not enough contrast!

**Solution:** Make filename significantly darker/bolder:

```lua
-- Light mode normal (and other light modes)
WinBarFileName = {
    class_id = "WinBarFileName",
    values = { fg = colors.light.gray[9], bg = colors.light.basics.bg, nocombine = true, bold = true },
    --              ^^^^^^^^^^^^^^^^                                                      ^^^^^^^^^^^
    --              Darker: gray[9] instead of gray[7]                                   Add bold
},
```

**Apply to these sections:**
- `active.light.normal.WinBarFileName`
- `active.light.insert.WinBarFileName`
- `active.light.visual.WinBarFileName`
- `active.light.command.WinBarFileName`

#### B. Add `WinBarAlertYellow` Highlight Group

Add for all theme × mode × active/inactive combinations (10 sections total).

**Pattern:**

```lua
WinBarAlertYellow = {
    class_id = "WinBarAlertYellow",
    values = { fg = colors.{light/dark}.yellow[X], bg = colors.{light/dark}.{mode_bg}, nocombine = true, bold = false },
},
```

**Sections to update:**

| Section | Background Color | Yellow FG |
|---------|------------------|-----------|
| `active.light.normal` | `colors.light.basics.bg` | `colors.light.yellow[5]` |
| `active.light.insert` | `colors.light.green[0]` | `colors.light.yellow[5]` |
| `active.light.visual` | `colors.light.yellow[0]` | `colors.light.yellow[5]` |
| `active.light.command` | `colors.light.purple[0]` | `colors.light.yellow[5]` |
| `active.dark.normal` | `colors.dark.basics.bg` | `colors.dark.yellow[2]` |
| `active.dark.insert` | `colors.dark.green[6]` | `colors.dark.yellow[2]` |
| `active.dark.visual` | `colors.dark.yellow[6]` | `colors.dark.yellow[2]` |
| `active.dark.command` | `colors.dark.purple[6]` | `colors.dark.yellow[2]` |
| `inactive.light.*` | `colors.light.basics.bg` | `colors.light.gray[4]` (grayed out) |
| `inactive.dark.*` | `colors.dark.basics.bg` | `colors.dark.gray[4]` (grayed out) |

---

### 6. `lua/core/autocmds.lua`

**No changes required.** Existing autocmds already trigger the necessary updates:
- `DiagnosticChanged` → updates diagnostics
- `BufEnter`, `BufFilePost` → updates file path/name
- `BufModifiedSet` → updates modified state
- `OptionSet` for `fileencoding` → updates encode

---

## Migration Checklist

1. [ ] Update `components_map` in `main.lua` (diagnostics state type, encode getter)
2. [ ] Update `get_diagnostics()` in `file.lua` to return `{errors, warnings}`
3. [ ] Remove `get_encode()` from `file.lua`
4. [ ] Add `get_encode()` to `editor.lua` (as alert component)
5. [ ] Update verbose labels in `editor.lua` (`copilot:off`, `wrap:on`, `save:off`, `save:partial`)
6. [ ] Restructure `render()` in `main.lua` for left-right layout
7. [ ] Fix light mode filename emphasis in `preset.lua` (darker + bold)
8. [ ] Add `WinBarAlertYellow` to all sections in `preset.lua`
9. [ ] Test all scenarios:
   - Normal file, no errors
   - File with errors only
   - File with warnings only
   - File with both errors and warnings
   - Modified file (should be red, no `+`)
   - Copilot disabled
   - Wrap enabled
   - Autowrite disabled/partial
   - Non-UTF-8 file
   - Oil buffer
   - All vim modes (normal, insert, visual, command)
   - Active vs inactive windows

---

## Visual Examples

### Light Theme, Normal Mode, Clean State
```
lua/plugins/blink.lua                                            nvim-dev:main
[dimmed path]     [prominent filename]                           [dimmed context]
```

### Light Theme, Normal Mode, With Issues
```
lua/plugins/blink.lua E:3 W:2                    nvim-dev:main copilot:off wrap:on
[dimmed] [prominent]  [red][yellow]              [dimmed]      [red]       [red]
```

### Modified File
```
lua/plugins/blink.lua                                            nvim-dev:main
              ^^^^^^^^^ (red = WinBarFileNameModified)
```

### Insert Mode (green background on winbar)
```
lua/plugins/blink.lua E:1                                        nvim-dev:main
[entire winbar has subtle green background tint]
```

---

## Open Questions

1. **Separator between path and filename**: Currently `/`. Confirm this is acceptable.

2. **Separator between cwd and branch**: Currently `:`. Alternatives: `/`, ` `, `@`.

3. **Flag order**: Currently `copilot → wrap → save → encode`. Any preference?

4. **Spacing**: Single space between all components. Any preference for more breathing room?

---

## Research-Based Rationale

### Why Left-Right Split?

Based on UX research on eye tracking, visual hierarchy, and editor conventions:

1. **Eye tracking patterns**: F-pattern and Z-pattern scanning establish left edge as natural anchor point
2. **Visual stability**: Fixed left positioning reduces cognitive load vs. variable centering
3. **Industry convention**: VS Code, JetBrains, lualine all use left=primary, right=secondary
4. **Cognitive load theory**: Predictable positioning eliminates mental work of locating information
5. **Information foraging**: Consistent left-edge placement creates reliable "information scent"

**Critical insight: The "code below" advantage**

When coding, your eyes are already on the left side of the screen (reading left-aligned code). A left-anchored winbar means **zero horizontal eye movement** to check filename/diagnostics—just glance up. This is optimal Fitts' Law application: minimal distance from code → winbar → back to code.

### Why "Show Only When Abnormal"?

- Reduces visual noise
- Abnormal states become immediately noticeable
- Aligns with Unix philosophy: silence means "everything is fine"
- Makes the winbar self-cleaning—most of the time, it's minimal

### Why Color Instead of `+` for Modified?

- Color is already being used for other alerts (errors, flags)
- Removes visual clutter (one less character)
- Maintains consistency with the "color indicates state" pattern
- Modified files are visually distinct without explicit symbols

### Design Decisions

| Component | Decision | Rationale |
|-----------|----------|-----------|
| **Filepath** | Keep full path (Option A) | Provides disambiguation for same-named files; dimmed so it doesn't demand attention; can remove later if unused |
| **cwd** | Keep temporarily | Needed until moved to OS bar; provides project context |
| **branch** | Keep always | Frequently checked; git context important for workflow |
| **line:col** | Don't include | Doesn't help code faster; not needed for this user's workflow |
| **Filename emphasis** | Darker + bold in light mode | Current gray[7] doesn't contrast enough with gray path; use gray[9] + bold |

---

Ready for implementation.
