# opm.nvim

Oracle-powered solo RPG tools for Neovim.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

opm.nvim brings oracle-powered solo RPG tools to your editor. Generate characters, creatures, adventures, and seek answers from the oracle — all without leaving Neovim.

## Features

- **Fate Oracle** — Ask Yes/No questions with 9 odds levels
- **Meaning Tables** — Action and description word pairs for scene inspiration
- **Character Crafter** — Identity, Mind, Body, Talent and Statistics
- **Creature Crafter** — Appearance, Behavior, Ability and Statistics
- **Behavior Engine** — Character and creature behavior context
- **Adventure Crafter** — Plot themes and turning points
- **Mystery Crafter** — Discovery checks and mystery descriptors

## Installation

### packer.nvim

```lua
use 'Django0033/opm.nvim'
```

### lazy.nvim

```lua
{
  'Django0033/opm.nvim',
  opts = {},
  config = function(_, opts)
    require('opm').setup(opts)
  end,
}
```

### vim.pack (Native, Neovim 0.11+)

```lua
vim.pack.add({
  'Django0033/opm.nvim'
})
```

## Commands

| Command | Description |
|---------|-------------|
| `:Opm` | Open command picker (requires telescope.nvim) |
| `:OpmFate {question}[:{odds}]` | Ask the oracle (default: fifty_fifty) |
| `:OpmAction` | Random action word pair |
| `:OpmDescription` | Random description word pair |
| `:OpmCharacter` | Generate a character with all aspects |
| `:OpmCharacterBehavior` | Roll for character behavior context |
| `:OpmCreature` | Generate a creature with all aspects |
| `:OpmCreatureBehavior` | Roll for creature new behavior |
| `:OpmAdventure` | Generate adventure plot (prompts for theme) |
| `:OpmMysteryCheck {box_count}` | Discovery Check: d100 + box count |
| `:OpmMysteryDescriptor` | Roll 2 Mystery Descriptor words |

### Fate Oracle

The Fate Oracle answers Yes/No questions. Run with no arguments for interactive mode, or pass the question and optional odds.

**Interactive mode:**
```vim
:OpmFate
```
Prompts for a question, then opens a menu to select odds.

**Direct mode** — question and odds separated by `:`:
```vim
:OpmFate Is the door locked?
:OpmFate Is the door locked?:likely
```

Press `<Tab>` after `:` to autocomplete odds from the table below.

**Odds levels:**

| Odds | Result |
|------|--------|
| `impossible` | Almost always No |
| `nearly_impossible` | Very rarely Yes |
| `very_unlikely` | Rarely Yes |
| `unlikely` | Sometimes Yes |
| `fifty_fifty` | Equal chance (default) |
| `likely` | Sometimes No |
| `very_likely` | Rarely No |
| `nearly_certain` | Very rarely No |
| `certain` | Almost always Yes |

## Usage

Run any command and a floating window appears. Press `<CR>` to insert the result into your markdown file. Press `y` to copy to clipboard or `q` to close.

Full documentation is available inside Neovim:

```vim
:help opm
```

### Template Expansion

Write a shorthand template and press `<leader>rx` to expand it inline:

```vim
tbl: Action                  " expands to: tbl: Action 2d100=32,19 -> Decrease/Conclude
gen: Character               " expands to: gen: Character ... (5 lines)
? Is the door locked?        " expands to: ? Is the door locked?\n-> Fate (50/50) d100=47 -> Yes
```

Fate questions support optional odds separated by `:`:
```vim
? Can I climb the wall? :likely
```

Press `<leader>r?` to expand a Fate question on the current line.

### Output Format

**Fate questions** follow:
```
? Is the door locked?
-> Fate (50/50) d100=47 -> Yes
```

**Table results** follow: `tbl: <name> <dice>=<roll> -> <result>`

```
tbl: Action 2d100=32,19 -> Decrease/Conclude
tbl: Character Behavior d100=42 -> Is helpful
tbl: Creature Behavior d10=7 -> Next expected step, or greater intensity
```

**Generation results** use `gen:` with multi-line output:

```
gen: Character
    Identity: d100=12 -> Academic
    Mind: d100=45 -> Behavioral
    Body: d100=78 -> Athletic
    Talent: d100=33 -> Combat
    Statistics: d10=8 -> About 25% higher
```

```
gen: Creature
    Appearance: 2d100=12,45 -> Brutish/Large
    Behavior: d10=6 -> Attacking, aggressive
    Ability: 2d100=33,77 -> Fire/Flight
    Statistics: d10=4 -> What you expect
```

```
gen: Adventure
    [1] (Action) d100=3 -> Attack
    [2] (Tension) d100=14 -> Ambush
    [3] (Mystery) d100=19 -> Secret
    [4] (Social) d100=26 -> Negotiation
    [5] (Personal) d100=6 -> Clue
```

```
tbl: Mystery Check d100+5=47 -> New Clue not connected
tbl: Mystery Descriptor 2d100=23,67 -> Discover/New
```

## Configuration

```lua
require('opm').setup({
  keymaps = {
    picker              = "<leader>rr",
    fate                = "<leader>rf",
    action              = "<leader>ra",
    description         = "<leader>rd",
    character           = "<leader>rc",
    character_behavior  = false,
    creature            = "<leader>rm",
    creature_behavior   = false,
    adventure           = "<leader>rv",
    mystery_check       = false,
    mystery_descriptor  = false,
    expand              = "<leader>rx",
    expand_fate         = "<leader>r?",
  },
  float = {
    border = "rounded",  -- border style
    height = 0.4,       -- window height
    width = 0.6          -- window width
  }
})
```

Set a keymap to `false` to disable it.

## Requirements

- Neovim 0.8+
- Neovim 0.11+ for vim.pack installation
