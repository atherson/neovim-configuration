# pragma-once.nvim

Automatically inserts `#pragma once` when you open a **new** `.h`, `.hpp`, `.hxx`, or `.hh` file in Neovim.

## Installation

### lazy.nvim (recommended for AstroNvim)

```lua
{
  dir = "~/.config/nvim/lua/plugins/pragma-once.nvim", -- if placed locally
  -- OR if you push it to GitHub:
  -- "yourusername/pragma-once.nvim",
  ft = { "c", "cpp" },
  opts = {},
}
```

For a **local plugin** (no GitHub repo needed), place the folder anywhere and use:

```lua
-- in ~/.config/nvim/lua/plugins/pragma_once.lua
return {
  dir = vim.fn.stdpath("config") .. "/pack/local/pragma-once.nvim",
  opts = {},
}
```

Or add to your packpath directly (no plugin manager needed):

```
~/.config/nvim/pack/local/start/pragma-once.nvim/
```

### Configuration

```lua
require("pragma_once").setup({
  -- Insert a blank line after #pragma once (default: true)
  blank_line = true,

  -- Only act on truly new files (empty buffer + not on disk). (default: true)
  -- Set to false to also trigger on empty existing files.
  only_new_files = true,
})
```

## Usage

- **Automatic**: just open a new `.h` / `.hpp` file — pragma is inserted instantly.
- **Manual**: run `:PragmaOnce` to insert at the top of any open buffer.

## How it works

Uses `BufNewFile` (fires only when Neovim creates a buffer for a file that doesn't exist on disk yet), so it will never clobber an existing file. The `only_new_files` guard double-checks that the buffer is empty before inserting.
