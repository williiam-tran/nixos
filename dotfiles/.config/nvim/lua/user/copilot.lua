-- vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_assume_unmapped = true
-- vim.api.nvim_set_keymap("i", "<tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.g.copilot_filetypes = {
  ["*"] = true,
  -- ["javascript"] = true,
  -- ["typescript"] = true,
  -- ["lua"] = true,
  -- ["rust"] = true,
  -- ["c"] = true,
  -- ["c#"] = true,
  -- ["c++"] = true,
  -- ["go"] = true,
  -- ["python"] = true,
}
