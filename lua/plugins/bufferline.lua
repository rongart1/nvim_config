return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'BufAdd',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        numbers = 'ordinal',
        diagnostics = 'nvim_lsp',
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = 'slant',
        sort_by = 'insert_after_current',
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'center',
            separator = true,
          },
        },
      },
    }

    -- Keymaps like AstroNvim
    vim.keymap.set('n', '<Tab>', '<cmd>BufferLineCycleNext<CR>', {})
    vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', {})
    vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
  end,
}
