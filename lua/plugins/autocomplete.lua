-- lua/plugins/blink-cmp.lua
return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {},
        opts = function(_, opts)
          require('luasnip.loaders.from_lua').lazy_load {
            paths = { vim.fn.stdpath 'config' .. '/lua/snippets' },
          }
        end,
      },
      'folke/lazydev.nvim',
    },
    opts = {

      keymap = {
        preset = 'none',

        ['<S-y>'] = { 'accept' },

        -- Navigate items
        ['<S-j>'] = { 'select_next' },
        ['<S-k>'] = { 'select_prev' },

        -- Show documentation (mapped to Shift-H for safety)
        ['<S-h>'] = { 'show_documentation' },

        -- Optional: cancel menu with Escape
        ['<Esc>'] = { 'cancel', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },
}
