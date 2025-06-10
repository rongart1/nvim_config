return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          local jdtls = require 'jdtls'
          local home = os.getenv 'HOME'

          local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
          local root_dir = require('jdtls.setup').find_root(root_markers)
          if not root_dir then
            print '❌ No root_dir found for jdtls'
            return
          end

          local workspace_dir = home .. '/.cache/jdtls/workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
          local config = {
            cmd = {
              'jdtls',
              '-configuration',
              home .. '/.cache/jdtls/config',
              '-data',
              workspace_dir,
            },
            root_dir = root_dir,
            settings = {
              java = {
                configuration = {
                  runtimes = {},
                },
                imports = {
                  gradle = {
                    wrapper = {
                      enabled = false,
                      checksums = {}, -- disables security warning
                    },
                  },
                },
                signatureHelp = { enabled = true },
                contentProvider = { preferred = 'fernflower' },
                completion = {
                  favoriteStaticMembers = {
                    'org.junit.Assert.*',
                    'org.junit.jupiter.api.Assertions.*',
                    'org.mockito.Mockito.*',
                  },
                },
                sources = {
                  organizeImports = {
                    starThreshold = 9999,
                    staticStarThreshold = 9999,
                  },
                },
                codeGeneration = {
                  toString = {
                    template = '${object.className}{${member.name()}=${member.value}, }',
                  },
                },
              },
            },
          }

          jdtls.start_or_attach(config)

          vim.keymap.set('n', '<leader>jg', function()
            vim.lsp.buf.code_action()
          end, { buffer = true, desc = 'Generate Java code' })
        end,
      })
    end,
  },
}
