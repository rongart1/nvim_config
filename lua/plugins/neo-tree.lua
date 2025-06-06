return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        position = 'left',
        width = 32,
        mappings = {
          ['<space>'] = 'none',
          ['l'] = 'open',
          ['h'] = 'close_node',
          ['<cr>'] = 'open',
          ['<esc>'] = 'cancel',
          ['a'] = 'add',
          ['d'] = 'delete',
          ['r'] = 'rename',
        },
      },
    }

    -- Keybind to toggle file explorer like AstroNvim
    vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Explorer' })
  end,
}
