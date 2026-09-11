-- Auto-setup with defaults when the plugin is loaded without explicit setup().
-- If the user calls require("pragma_once").setup(...) in their config,
-- the augroup is cleared and recreated with their options.
if vim.g.pragma_once_loaded then
  return
end
vim.g.pragma_once_loaded = true

require("pragma_once").setup()
