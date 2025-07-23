return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Safe setup for linters by filetype
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        lua = { 'luacheck' },
        javascript = { 'eslint_d' },
        typescript = { 'eslint_d' },
        json = { 'jsonlint' },
        python = { 'flake8' },
      }

      -- Optional: fallback linter for any filetype
      lint.linters_by_ft['*'] = { 'cspell' } -- or nil to disable

      -- Lint on file events
      local lint_augroup = vim.api.nvim_create_augroup('Linting', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })

      -- Optional: auto-reload linters on filetype change (useful for lazy-loaded ftplugins)
      vim.api.nvim_create_autocmd('FileType', {
        group = lint_augroup,
        callback = function()
          if lint.linters_by_ft[vim.bo.filetype] then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
