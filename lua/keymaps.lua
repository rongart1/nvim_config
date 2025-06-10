-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- double pressing j will go to normal mode
vim.keymap.set('i', 'jj', '<Esc>')

-- opens terminal in insert mode and reuses existing buffer
local term_buf = nil
local term_win = nil

vim.keymap.set('n', '<leader>t', function()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    -- Reuse existing buffer
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_set_current_win(term_win)
    else
      vim.cmd 'split'
      term_win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(term_win, term_buf)
    end
  else
    -- Create new terminal
    vim.cmd 'split'
    vim.cmd 'terminal'
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

vim.keymap.set('n', '<leader>r', function()
  local file = vim.fn.expand '%:p'
  local filename = vim.fn.expand '%:t:r'
  local dir = vim.fn.expand '%:p:h'
  vim.cmd('vsplit | terminal cd ' .. dir .. ' && javac ' .. file .. ' && java ' .. filename)
end, { desc = 'Run current Java file' })
