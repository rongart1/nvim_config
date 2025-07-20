return {
  'folke/zen-mode.nvim',
  keys = {
    {
      '<leader>z',
      function()
        require('zen-mode').toggle()
      end,
      desc = 'Toggle Zen Mode',
    },
  },
  opts = {
    window = {
      backdrop = 0.95,
      width = 100,
      height = 1,
      options = {
        signcolumn = 'no',
        number = true,
        relativenumber = true,
        cursorline = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
      },
      twilight = { enabled = false },
      gitsigns = { enabled = false },
      tmux = { enabled = true }, -- disables tmux status bar
    },
  },
}
