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

### Remaining (manual review / future)

- `lua/opm/dice.lua:11` — `M.roll_dice(sides)` is exported but never called internally. Kept as reasonable public API for users who may call `require("opm.dice").roll_dice(20)` from their config.
- Range-lookup pattern (`roll_in_range`) still scattered across `behavior.lua`, `mystery.lua`, `meaning.lua`, and `plugin/opm.lua` — could be extracted to a shared utility module in a future refactor.
