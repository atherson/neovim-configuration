local M = {}

M.defaults = {
  -- Extra blank line after #pragma once
  blank_line = true,
  -- Only insert when the file is genuinely new (empty buffer, non-existent on disk)
  only_new_files = true,
}

M.opts = {}

--- Returns true when the buffer should receive the pragma.
---@param bufnr integer
local function should_insert(bufnr)
  if M.opts.only_new_files then
    local filepath = vim.api.nvim_buf_get_name(bufnr)
    -- File must not exist on disk yet
    if vim.fn.filereadable(filepath) == 1 then
      return false
    end
    -- Buffer must be empty
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local content = table.concat(lines, "")
    if content ~= "" then
      return false
    end
  end
  return true
end

--- Inserts #pragma once (and optional blank line) at the top of the buffer.
---@param bufnr integer
local function insert_pragma(bufnr)
  if not should_insert(bufnr) then
    return
  end

  local to_insert = { "#pragma once" }
  if M.opts.blank_line then
    table.insert(to_insert, "")
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, to_insert)

  -- Place cursor after the pragma (line 2 if blank_line, else line 1)
  local target_line = M.opts.blank_line and 2 or 1
  -- Schedule so the window is ready
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      local win = vim.fn.bufwinid(bufnr)
      if win ~= -1 then
        vim.api.nvim_win_set_cursor(win, { target_line, 0 })
      end
    end
  end)
end

--- Sets up the autocommand group.
local function setup_autocmd()
  local group = vim.api.nvim_create_augroup("PragmaOnce", { clear = true })
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = group,
    pattern = { "*.h", "*.hpp", "*.hxx", "*.hh" },
    desc = "Insert #pragma once in new C/C++ header files",
    callback = function(ev)
      insert_pragma(ev.buf)
    end,
  })
end

--- Public command to manually insert pragma in the current buffer.
local function setup_command()
  vim.api.nvim_create_user_command("PragmaOnce", function()
    local bufnr = vim.api.nvim_get_current_buf()
    -- Override the guard when called manually
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local to_insert = { "#pragma once" }
    if M.opts.blank_line then
      table.insert(to_insert, "")
    end
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, to_insert)
    vim.notify("pragma-once: inserted #pragma once", vim.log.levels.INFO)
  end, { desc = "Manually insert #pragma once at the top of the current file" })
end

---@param user_opts? table
function M.setup(user_opts)
  M.opts = vim.tbl_deep_extend("force", M.defaults, user_opts or {})
  setup_autocmd()
  setup_command()
end

return M
