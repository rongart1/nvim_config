-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- double pressing j will go to normal mode
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('i', 'kk', '<Esc>')

-- opens terminal in insert mode and reuses existing buffer
local term_buf = nil
local term_win = nil

vim.keymap.set('n', '<leader>T', function()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    -- Reuse existing buffer
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_set_current_win(term_win)
    else
      vim.cmd 'split'
      vim.cmd 'res -20'
      term_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(term_win, term_buf)
    end
  else
    -- Create new terminal
    vim.cmd 'split'
    vim.cmd 'terminal'
    vim.cmd 'res -20'
    term_win = vim.api.nvim_get_current_win()
    term_buf = vim.api.nvim_get_current_buf()
  end

  -- Go to insert mode
  vim.cmd 'startinsert'
end, { noremap = true, silent = true, desc = 'Open/reuse bottom terminal' })

-- Clear highlights on search when pressing <Esc> in normal mode
vim.api.nvim_create_autocmd('CmdlineLeave', {
  pattern = '/,?',
  callback = function()
    vim.schedule(function()
      vim.cmd 'nohlsearch'
    end)
  end,
})

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- keep these at top-level so they persist across <leader>r invocations
local java_winid, java_bufnr

vim.keymap.set('n', '<leader>r', function()
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
