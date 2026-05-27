# opm.nvim

Oracle-powered solo RPG tools for Neovim.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

opm.nvim brings oracle-powered solo RPG tools to your editor. Generate characters, creatures, adventures, and seek answers from the oracle — all without leaving Neovim.

## Features

- **Fate Oracle** - Ask Yes/No questions with 9 odds levels
- **Meaning Tables** - Action and description word pairs for scene inspiration
- **Character Crafter** - Identity, Mind, Body, and Talent keywords
- **Behavior Engine** - Character motivation and context
- **Adventure Crafter** - Plot themes and turning points
- **Creature Crafter** - Appearance, behavior, and abilities

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
| `:OpmFate {question} [{odds}]` | Ask the oracle (default: fifty_fifty) |
| `:OpmAction` | Random action word pair |
| `:OpmDescription` | Random description word pair |
| `:OpmCharacter` | Generate a character |
| `:OpmCharacterBehavior` | Character behavior context |
| `:OpmCreature` | Generate a creature |
| `:OpmAdventure` | Generate adventure plot |

**Odds options:** impossible, nearly_impossible, very_unlikely, unlikely, fifty_fifty, likely, very_likely, nearly_certain, certain

## Usage

Run any command and a floating window appears. Press `<CR>` to insert the result into your markdown file.

### Output Format

**Table results** follow: `tbl: <name> <dice>=<roll> -> <result>`

**Character generation** uses:
```
gen: Character
    <aspect>: d100=<roll> -> <word>
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