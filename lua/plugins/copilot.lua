return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- GitHub Copilot itself
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- Required dependency
    },
    build = 'make tiktoken', -- Only required on Mac/Linux for tokenizer
    opts = {
      -- Optional: config goes here, e.g.
      show_help = 'yes',
    },
    config = function(_, opts)
      require('CopilotChat').setup(opts)
    end,
    keys = {
      -- Normal mode: Open Copilot Chat window
      { '<leader>aa', ':CopilotChat<CR>', mode = 'n', desc = 'Copilot: Open Chat Window' },

      -- Visual mode: Contextual actions
      { '<leader>ae', ':CopilotChatExplain<CR>', mode = 'v', desc = 'Copilot: Explain Selection' },
      { '<leader>ar', ':CopilotChatReview<CR>', mode = 'v', desc = 'Copilot: Review Selection' },
      { '<leader>af', ':CopilotChatFix<CR>', mode = 'v', desc = 'Copilot: Fix Issues in Selection' },
      { '<leader>ao', ':CopilotChatOptimize<CR>', mode = 'v', desc = 'Copilot: Optimize Code' },
      { '<leader>ad', ':CopilotChatDocs<CR>', mode = 'v', desc = 'Copilot: Generate Documentation' },
      { '<leader>at', ':CopilotChatTests<CR>', mode = 'v', desc = 'Copilot: Generate Tests' },

      -- Commit message generation
      { '<leader>am', ':CopilotChatCommit<CR>', mode = 'n', desc = 'Copilot: Commit Message (Buffer)' },
      { '<leader>as', ':CopilotChatCommit<CR>', mode = 'v', desc = 'Copilot: Commit Message (Selection)' },
    },
  },
}
