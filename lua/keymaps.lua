-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- double pressing j will go to normal mode
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'kk', '<Esc>')

-- Clear highlights on search when pressing <Esc> in normal mode
-- vim.api.nvim_create_autocmd('CmdlineLeave', {
--   pattern = '/,?',
--   callback = function()
--     vim.schedule(function()
--       vim.cmd 'nohlsearch'
--     end)
--   end,
-- })
--
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- keep these at top-level so they persist across <leader>r invocations
local java_winid, java_bufnr

vim.keymap.set('n', '<leader>rj', function()
  -- if there’s an old run open, close its window + delete its buffer
  if java_winid and vim.api.nvim_win_is_valid(java_winid) then
    vim.api.nvim_win_close(java_winid, true)
  end
  if java_bufnr and vim.api.nvim_buf_is_valid(java_bufnr) then
    vim.api.nvim_buf_delete(java_bufnr, { force = true })
  end

  -- save current file
  vim.cmd 'write'

  -- determine package & class
  local filepath = vim.fn.expand '%:p'
  local classname = vim.fn.expand '%:t:r'
  local dir = vim.fn.expand '%:p:h'
  local pkg
  for line in io.lines(filepath) do
    local m = line:match '^%s*package%s+([%w%.]+)%s*;'
    if m then
      pkg = m
      break
    end
  end
  local class_to_run = (pkg and pkg .. '.' .. classname) or classname

  -- open new split + run
  vim.cmd 'w'
  vim.cmd 'vsplit'
  java_winid = vim.api.nvim_get_current_win()
  vim.cmd('terminal cd ' .. dir .. ' && javac -d . *.java && java ' .. class_to_run)
  java_bufnr = vim.api.nvim_get_current_buf()
end, { desc = 'Run current Java file (with package)' })
