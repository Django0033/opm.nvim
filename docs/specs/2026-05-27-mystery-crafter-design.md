# Design Spec: One-Page Mystery Crafter

**Date**: 2026-05-27
**Status**: Design approved, pending implementation

## Overview

Add two stateless commands for the One-Page Mystery Crafter system: Discovery Check and Mystery Descriptors. Both follow the existing `tbl:` output format pattern.

## Commands

### `:OpmMysteryCheck {box_count}`

Discovery Check — the core mechanic. Roll 1d100 + current number of boxes on the Mystery Matrix, look up the result in the Discovery Check table.

**Input**: box_count (number, 0-20)
**Output format**: `tbl: Mystery Check d100+X=YY -> result`

### `:OpmMysteryDescriptor`

Roll on the Mystery Descriptors table for inspiration when adding a new box to the Matrix.

**Input**: none
**Output format**: `tbl: Mystery Descriptor d100=XX -> word`

## Files

| File | Purpose |
|------|---------|
| `lua/opm/tables/mystery.lua` | Discovery Check table (7 ranges) + Descriptors table (100 entries) |
| `lua/opm/mystery.lua` | `roll_check(box_count)`, `roll_descriptor()` |
| `plugin/opm.lua` | `:OpmMysteryCheck`, `:OpmMysteryDescriptor` |
| `doc/opm.txt` | Help section |
| `README.md` | Commands table + output examples |
| `docs/specs/2026-05-27-mystery-crafter-design.md` | This file |

## Discovery Check Table (range-based, 7 entries)

| Min | Max | Result |
|-----|-----|--------|
| 1 | 15 | Nothing useful found |
| 16 | 35 | New Suspect not connected |
| 36 | 50 | New Clue not connected |
| 51 | 70 | New Clue connected to a Suspect |
| 71 | 80 | New Suspect connected to a Clue |
| 81 | 100 | Connect existing Clue to existing Suspect |
| 101 | — | Definitive clue — connected Suspect is the answer |

The last entry has no max — any result >=101 matches.

## Mystery Descriptors Table (index-based, 100 entries)

1d100 simple index table. 100 single words (Accident, Aggressive, Ambition... Witness).

## Roll Logic

### `roll_check(box_count)`
1. Roll 1d100
2. Add box_count to the roll
3. Find first range where total >= min and (total <= max or no max)
4. Return { roll = d100_value, boxes = box_count, total = d100 + boxes, result = string }

### `roll_descriptor()`
1. Roll 1d100
2. Return word at that index from the descriptors table
3. Return { roll, word }

## Output Examples

```
Mystery Check
────────────────────────────────────────
tbl: Mystery Check d100+5=47 -> New Clue not connected

  Press 'q' to close | 'y' to copy
  Press <CR> to insert
```

```
Mystery Descriptor
────────────────────────────────────────
tbl: Mystery Descriptor d100=23 -> Discover

  Press 'q' to close | 'y' to copy
  Press <CR> to insert
```

## Architecture Notes

- Follows existing pattern: table file + module file + command + help
- Stateless — no session persistence needed
- Uses existing `dice.roll_d100()` and `tables` auto-loader
- Descriptors table uses simple index (not range-based) matching `character.lua` pattern
- Check table uses range-based lookup matching `behavior.lua` pattern

## Tasks

1. Create `lua/opm/tables/mystery.lua`
2. Create `lua/opm/mystery.lua`
3. Add commands to `plugin/opm.lua`
4. Update `doc/opm.txt`
5. Update `README.md`
6. Run tests (13/13 must pass)
