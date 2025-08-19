return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- optional, for file icons
  keys = {
    {
      '-',
      function()
        require('oil').open()
      end,
      desc = 'Oil: Open parent directory',
    },
    {
      '<leader>o',
      function()
        require('oil').open_float()
      end,
      desc = 'Oil: Floating file manager',
    },
  },
  opts = {
    -- Make Oil replace netrw and act as the default file explorer
    default_file_explorer = true,

    -- UI/Columns
    columns = { 'icon', 'permissions', 'size', 'mtime' },
    win_options = { signcolumn = 'yes', wrap = false },

    -- Floating window settings (used by :lua require('oil').open_float())
    float = {
      padding = 2,
      max_width = 100,
      max_height = 30,
      border = 'rounded',
      win_options = { winblend = 0 },
    },

    -- Behavior
    delete_to_trash = true, -- use your system trash when deleting
    skip_confirm_for_simple_edits = true, -- less prompting for rename/move within the same dir
    watch_for_changes = true, -- auto-refresh when files change

    -- Visibility & sorting
    view_options = {
      show_hidden = true, -- show dotfiles (toggle with "g.")
      natural_order = true, -- sort numbers like 1,2,10
      case_insensitive = true, -- sorting ignores case
      is_always_hidden = function(name, _)
        -- Always hide these (even with show_hidden=true)
        return name == '.git' or name == 'node_modules'
      end,
    },

    -- Keep Oil's defaults and add a few ergonomic extras below
    use_default_keymaps = true,

    -- Extra keymaps (valid only in the Oil buffer)
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = 'actions.select_split',
      ['<C-v>'] = 'actions.select_vsplit',
      ['<C-t>'] = 'actions.select_tab',

      ['q'] = 'actions.close',
      ['<Esc>'] = 'actions.close',
      ['gr'] = 'actions.refresh',
      ['gp'] = 'actions.preview',

      ['-'] = 'actions.parent',
      ['<BS>'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['~'] = 'actions.tcd',

      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
    },
  },
}
