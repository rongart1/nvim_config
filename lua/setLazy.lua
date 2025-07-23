-- Automatically install lazy.nvim if not present
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)
require('lazy').setup({
  -- Import plugins from external modules (e.g. lua/plugins/*.lua)
  { import = 'plugins' },
  { import = 'plugins.treesitter' },

  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = true,
  },

  -- ✅ Highlight TODO/FIXME/HACK etc.
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- 💡 Mini.nvim for AI, surround, statusline
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}, {
  -- Lazy.nvim UI configuration
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
vim.o.background = 'dark' -- or "light"

require('gruvbox').setup {
  contrast = 'soft', -- options: soft, medium, hard
  transparent_mode = true,
}

vim.cmd.colorscheme 'gruvbox'
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
