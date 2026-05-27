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

## Installation

### packer.nvim

```lua
use 'Django0033/opm.nvim'
```

### lazy.nvim

```lua
{
  'Django0033/opm.nvim',
  opts = {}
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
| `:OpmFate {question}[:{odds}]` | Ask the oracle (default: fifty_fifty) |
| `:OpmAction` | Random action word pair |
| `:OpmDescription` | Random description word pair |
| `:OpmCharacter` | Generate a character with all aspects |
| `:OpmCharacterBehavior` | Roll for character behavior context |
| `:OpmCreature` | Generate a creature with all aspects |
| `:OpmCreatureBehavior` | Roll for creature new behavior |
| `:OpmAdventure` | Generate adventure plot |

**Odds options:** impossible, nearly_impossible, very_unlikely, unlikely, fifty_fifty, likely, very_likely, nearly_certain, certain

## Usage

Run any command and a floating window appears. Press `<CR>` to insert the result into your markdown file. Press `y` to copy to clipboard or `q` to close.

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

## Configuration

```lua
require('opm').setup({
  float = {
    border = "rounded",  -- border style
    height = 0.4,       -- window height
    width = 0.6          -- window width
  }
})
```

## Requirements

- Neovim 0.8+
- Neovim 0.11+ for vim.pack installation
