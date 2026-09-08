---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- ── Options ────────────────────────────────────────────────────
    options = {
      opt = {
        number = true,
        relativenumber = false,
        signcolumn = "yes", -- always show; prevents layout shift
        scrolloff = 8, -- keep context lines visible
        sidescrolloff = 8,
        wrap = false, -- no soft-wrap (good for wide C++ lines)
        colorcolumn = "100", -- visual guide at 100 chars
        expandtab = true,
        shiftwidth = 4,
        tabstop = 4,
        updatetime = 200, -- faster CursorHold → faster LSP hints
        timeoutlen = 300,
        termguicolors = true,
      },
      g = {
        -- Catppuccin flavour: latte | frappe | macchiato | mocha
        catppuccin_flavour = "mocha",
      },
    },

    -- ── Colorscheme ────────────────────────────────────────────────
    colorscheme = "catppuccin",

    -- ── Keymaps ────────────────────────────────────────────────────
    mappings = {
      n = {
        -- Yazi: open file manager
        ["<Leader>e"] = { "<cmd>Yazi<CR>", desc = "File manager (Yazi)" },

        -- Quick build shortcut (works if you're in a CMake project)
        ["<Leader>cb"] = { "<cmd>!cmake --build build<CR>", desc = "CMake build" },

        -- Toggle relative line numbers
        ["<Leader>ul"] = {
          function() vim.opt.relativenumber = not vim.opt.relativenumber:get() end,
          desc = "Toggle relative numbers",
        },

        -- Faster buffer navigation
        ["<S-h>"] = { "<cmd>bprevious<CR>", desc = "Prev buffer" },
        ["<S-l>"] = { "<cmd>bnext<CR>", desc = "Next buffer" },
      },

      t = {
        -- Close Yazi terminal when it's open
        ["<Leader>e"] = { "<C-\\><C-n><cmd>close<CR>", desc = "Close Yazi" },
      },
    },

    -- ── Autocommands ───────────────────────────────────────────────
    autocmds = {

      yazi_backdrop_fix = {
        {
          event = "TermClose",
          pattern = "*yazi*",
          callback = function()
            vim.cmd "highlight clear YaziFloat"
            vim.opt.winblend = 0
          end,
        },
      },
      -- Insert #pragma once into new .h files
      header_template = {
        {
          event = "BufNewFile",
          pattern = "*.h",
          callback = function()
            if vim.fn.line "$" == 1 and vim.fn.getline(1) == "" then
              vim.api.nvim_buf_set_lines(0, 0, -1, false, {
                "#pragma once",
                "",
                "",
              })
              vim.api.nvim_win_set_cursor(0, { 3, 0 })
            end
          end,
        },
      },

      -- Auto-format on save for C/C++ files (clangd must be active)
      cpp_format = {
        {
          event = "BufWritePre",
          pattern = { "*.c", "*.cc", "*.cpp", "*.h", "*.hpp" },
          callback = function() vim.lsp.buf.format { async = false } end,
        },
      },

      -- Highlight yanked region briefly
      yank_highlight = {
        {
          event = "TextYankPost",
          pattern = "*",
          callback = function() vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 } end,
        },
      },
    },
  },
}
