# Code Deletion Log

## 2026-05-28 Refactor Session

### Dead Exports Made Local

| File | Item | Change |
|------|------|--------|
| `lua/opm/fate.lua:6` | `M.OddsError` | Exported but only used internally — made local `ODDS_ERROR` |
| `lua/opm/fate.lua:35` | `M.interpret_roll()` | Exported but only used internally by `roll_fate()` — made local |

### Dead Code Branch Removed

| File | Item | Reason |
|------|------|--------|
| `lua/opm/meaning.lua:32-41` | `else` branch in `roll_meaning()` | Never reached — all 10 callers pass `"action"` or `"description"`. The branch returned a `{ action, description }` result shape that didn't match what any caller consumed (`.word` access). |

### Impact

- Lines removed: 12 (net: 35 deleted, 23 added)
- Dead exports eliminated: 2
- Dead code branches eliminated: 1
- Files modified: 2 (fate.lua, meaning.lua)

### Testing

- All 13 tests passing (13 passed, 0 failed)

---

## 2026-05-27 Refactor Session

### Unused Exports Removed

| File | Item | Reason |
|------|------|--------|
| `lua/opm/init.lua:8` | `M.tables_dir = nil` | Dead assignment — set to nil, never assigned a real value, never read |
| `lua/opm/fate.lua:8-10` | `M.is_valid_odds(odds)` | Never called anywhere in codebase. Also buggy: checked string keys against numerically-indexed `ODDS_TYPES` array, always returned false |
| `lua/opm/constants.lua:40` | `M.DEFAULT_TABLES_DIR` | Never referenced anywhere in codebase |

### Bugs Fixed

| File | Issue | Fix |
|------|-------|-----|
| `tests/helper.lua:54` | `return true` in `_print_summary()` caused early function exit when failures existed, skipping `vim.cmd("cq")` — test runner would report exit 0 even on failures | Removed the `return true` statement |

### Duplicate Code Consolidated

| Consolidation | Files | Savings |
|---------------|-------|---------|
| Hardcoded odds list (2 copies) → `constants.ODDS_TYPES` | `plugin/opm.lua` | 8 lines |
| Duplicate stats range-lookup (2 copies) → `roll_statistics()` helper | `plugin/opm.lua` | 14 lines |
| Duplicate double-event notification (2 copies) → `show_double_event()` helper | `plugin/opm.lua` | 4 lines |

### Impact

- Lines of dead code removed: 5
- Lines saved via consolidation: ~26
- Bug fix (helper.lua): critical — was masking test failures
- Files modified: 5 (init.lua, fate.lua, constants.lua, plugin/opm.lua, helper.lua)

### Testing

- All 13 tests passing (13 passed, 0 failed)
- Test framework failure-detection bug fixed

## 2026-05-30 Refactor Session

### Dead Code Removed

| File | Item | Reason |
|------|------|--------|
| `lua/opm/expand.lua:51-53` | `local function roll_d100()` | Dead wrapper — just called `dice.roll_d100()`. Replaced all 6 callers with direct `dice.roll_d100()` calls. |
| `lua/opm/expand.lua:139` | `local box_count = nil` | Redundant `= nil` — variable is already nil by default in Lua |
| `plugin/opm.lua:10-19` | `local function roll_statistics(dice, tables)` | Duplicate of statistics lookup logic — moved to `dice.roll_statistics()` |
| `plugin/opm.lua:123-125` | `local function roll_d100()` | Dead wrapper — replaced 4 callers with direct `dice.roll_d100()` calls |
| `plugin/opm.lua:267` | Unused `total, result` variables in `OpmHexTerrain` | Never read after destructuring |
| `plugin/opm.lua:276` | Unused `total, result` variables in `OpmNewHex` | Never read after destructuring |

### Variable Renamed for Clarity

| File | Change |
|------|--------|
| `lua/opm/expand.lua:3` | `magic` → `meaning` (was importing `opm.meaning`) |

### Duplicate Code Consolidated

| Consolidation | Files | Savings |
|---------------|-------|---------|
| Statistics range lookup (3 copies) → `dice.roll_statistics()` | `expand.lua`, `plugin/opm.lua` | 15 lines removed |
| Dead `roll_d100()` wrappers removed (2 copies) | `expand.lua`, `plugin/opm.lua` | 6 lines removed |

### Impact

- Lines of dead code removed: ~24
- Duplicate functions consolidated: 1 (statistics lookup)
- Dead wrappers eliminated: 2 (`roll_d100` in 2 files)
- Unused variables cleaned: 4
- Files modified: 4 (expand.lua, plugin/opm.lua, dice.lua, DELETION_LOG.md)

### Files Changed

- `lua/opm/dice.lua` — Added `roll_statistics()` shared utility
- `lua/opm/expand.lua` — Removed `roll_d100()` wrapper, redundant nil init, renamed `magic` → `meaning`, used shared `dice.roll_statistics()`
- `plugin/opm.lua` — Removed `roll_d100()` wrapper, removed local `roll_statistics()`, cleaned unused variables, used shared `dice.roll_statistics()`

---
