# opm.nvim

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Neovim](https://img.shields.io/badge/Neovim-0.8%2B-green?style=flat-square&logo=neovim)](https://neovim.io)
[![Telescope](https://img.shields.io/badge/Telescope-optional-blue?style=flat-square&logo=lua)](https://github.com/nvim-telescope/telescope.nvim)

Solo RPG oracles, tables, and generators — all inside Neovim.

## Features

- **Fate Oracle** — Ask Yes/No questions with 9 odds levels + random events on doubles
- **Hex Map Generator** — Roll terrain, step through hexes with chaos, discover points of interest
- **Meaning Tables** — Action and description word pairs for scene inspiration
- **Character Crafter** — Identity, Mind, Body, Talent, and Statistics
- **Creature Crafter** — Appearance, Behavior, Ability, and Statistics
- **Behavior Engine** — Character and creature behavior context
- **Adventure Crafter** — Plot themes and turning points
- **Mystery Crafter** — Discovery checks and mystery descriptors
- **Location Crafter** — Procedural region exploration with exits
- **Template Expansion** — `tbl:`, `gen:`, `?` shorthand expandable inline
- **Telescope Picker** — Browse and run all commands via `:Opm`

## Installation

<details>
<summary><b>lazy.nvim</b></summary>

```lua
{
  'Django0033/opm.nvim',
  opts = {},
  config = function(_, opts)
    require('opm').setup(opts)
  end,
}
```
</details>

<details>
<summary><b>packer.nvim</b></summary>

```lua
use 'Django0033/opm.nvim'
```
</details>

<details>
<summary><b>vim.pack (Neovim 0.11+)</b></summary>

```lua
vim.pack.add({
  'Django0033/opm.nvim'
})
```
</details>

## Commands

| Command | Description |
|---------|-------------|
| `:Opm` | Open telescope command picker |
| `:OpmFate {question}[:{odds}]` | Ask the oracle (default: fifty_fifty) |
| `:OpmAction` | Random action word pair |
| `:OpmDescription` | Random description word pair |
| `:OpmCharacter` | Generate a full character |
| `:OpmCharacterBehavior` | Roll for character behavior context |
| `:OpmCreature` | Generate a full creature |
| `:OpmCreatureBehavior` | Roll for creature new behavior |
| `:OpmAdventure` | Generate adventure plot (prompts for theme) |
| `:OpmMysteryCheck {box_count}` | Discovery Check: d100 + box count |
| `:OpmMysteryDescriptor` | Roll 2 mystery descriptor words |
| `:OpmLocArea {PP}` | Roll Location/Encounter/Object for one area |
| `:OpmLocDescriptor` | Roll 2 location descriptor words |
| `:OpmLocExit [{PP}]` | Roll connector exits (prompts if no arg) |
| `:OpmHexTerrain` | Roll 2d10 for hex terrain type |
| `:OpmNewHex [{CF}]` | Roll 2d10 + chaos modifier for next hex (prompts if no arg) |
| `:OpmHexPOI` | Roll 2d10 + 1d6 for a hex point of interest |

## Usage

Run any command and a floating window appears. Press `<CR>` to insert the result into your buffer, `y` to copy, or `q` to close.

Full documentation available inside Neovim:

```vim
:help opm
```

### Template Expansion

Write a shorthand and press `<leader>rx` to expand inline:

```
tbl: Action                    → tbl: Action 2d100=32,19 -> Decrease/Conclude
tbl: Hex Terrain               → tbl: Hex Terrain 2d10=12 -> Grassland
tbl: New Hex 5                 → tbl: New Hex 2d10[4,7]+0=11 -> Current terrain +1 step
tbl: Hex POI                   → tbl: Hex POI 2d10=14 -> Monster's nest — (1d6=4) Breeding ground
gen: Character                 → gen: Character ... (5 lines)
gen: Area 3                    → gen: Area (PP=3) ... (3 lines)
? Is the door locked?          → ? Is the door locked?\n-> Fate (50/50) d100=47 -> Yes
```

Fate questions support `:odds` suffix:
```
? Can I climb the wall?:likely
```

Press `<leader>r?` to expand a Fate question on the current line.

### Hex Map Flow

Generate a hex map in 3 steps:

```vim
" 1. Roll starting terrain
:OpmHexTerrain
> tbl: Hex Terrain 2d10=12 -> Grassland

" 2. Roll next hex with chaos factor
:OpmNewHex 5
> tbl: New Hex 2d10[4,7]+0=11 -> Current terrain +1 step
"    ↑ doubles trigger WARN: "Point of Interest triggered! Roll OpmHexPOI"

" 3. Roll point of interest (when doubles occur)
:OpmHexPOI
> tbl: Hex POI 2d10=6 -> Barrow mounds — (1d6=5) An ancient king's burial, still guarded
```

Terrain order: Ocean → River/Coast → Swamp → Grassland → Forest/Jungle → Mountains → Desert/Arctic.

Chaos Factor (1–9) modifies the `2d10` roll for New Hex. Same terrain = CF+1, different = CF−1.

### Fate Oracle

Answer Yes/No questions with the Game Master Chart:

```vim
:OpmFate Is the door locked?:likely
```

Press `<Tab>` after `:` to autocomplete odds. Interactive mode with no arguments prompts for question + odds.

| Odds | Result |
|------|--------|
| `impossible` | Always No |
| `nearly_impossible` | Very rarely Yes |
| `very_unlikely` | Rarely Yes |
| `unlikely` | Sometimes Yes |
| `fifty_fifty` | Equal chance (default) |
| `likely` | Sometimes No |
| `very_likely` | Rarely No |
| `nearly_certain` | Very rarely No |
| `certain` | Almost always Yes |

## Configuration

```lua
require('opm').setup({
  keymaps = {
    picker              = "<leader>rr",
    fate                = "<leader>rf",
    action              = "<leader>ra",
    description         = "<leader>rd",
    character           = "<leader>rc",
    character_behavior  = "<leader>rb",
    creature            = "<leader>rm",
    creature_behavior   = "<leader>rw",
    adventure           = "<leader>rv",
    mystery_check       = "<leader>rk",
    mystery_descriptor  = "<leader>ry",
    location_area       = "<leader>rl",
    location_descriptor = "<leader>rs",
    location_exits      = "<leader>re",
    hex_terrain         = "<leader>rt",
    hex_new             = "<leader>rn",
    hex_poi             = "<leader>rp",
    expand              = "<leader>rx",
    expand_fate         = "<leader>r?",
  },
  float = {
    border = "rounded",
    height = 0.4,
    width  = 0.6,
  },
})
```

Set a keymap to `false` to disable it.

## Requirements

- Neovim 0.8+
- telescope.nvim (optional, for `:Opm` picker only)
