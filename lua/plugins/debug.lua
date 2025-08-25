-- lua/plugins/debug.lua
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'nvim-lua/plenary.nvim', -- for build helper
  },
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle DAP UI',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Ensure adapters via Mason
    require('mason-nvim-dap').setup {
      ensure_installed = { 'netcoredbg' },
      automatic_installation = true,
      handlers = {},
    }

    -- DAP UI with auto-open/close
    dapui.setup()
    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    -- Go debugging (kept from your config)
    require('dap-go').setup { delve = { detached = true } }

    -- Resolve netcoredbg path: try PATH, then Mason
    local netcoredbg_path = vim.fn.exepath 'netcoredbg'
    if netcoredbg_path == nil or netcoredbg_path == '' then
      local ok, mason_registry = pcall(require, 'mason-registry')
      if ok then
        local pkg = mason_registry.get_package 'netcoredbg'
        if pkg and pkg:is_installed() then
          netcoredbg_path = pkg:get_install_path() .. '/netcoredbg'
        end
      end
    end

    -- Adapter for .NET (CoreCLR)
    dap.adapters.coreclr = {
      type = 'executable',
      command = netcoredbg_path ~= '' and netcoredbg_path or 'netcoredbg',
      args = { '--interpreter=vscode' }, -- '--server' not needed
    }

    -- Helpers: build and pick DLL
    local function dotnet_build()
      local Job = require 'plenary.job'
      Job:new({
        command = 'dotnet',
        args = { 'build', '--configuration', 'Debug' },
        cwd = vim.fn.getcwd(),
      }):sync()
    end

    local function pick_dll()
      local cwd = vim.fn.getcwd()
      local list = vim.fn.glob(cwd .. '/bin/Debug/*/*.dll', 0, 1)
      if #list == 0 then
        dotnet_build()
        list = vim.fn.glob(cwd .. '/bin/Debug/*/*.dll', 0, 1)
      end
      return vim.fn.input('Path to DLL: ', list[1] or (cwd .. '/bin/Debug/'), 'file')
    end

    -- C# configurations
    dap.configurations.cs = {
      {
        type = 'coreclr',
        request = 'launch',
        name = 'Launch DLL',
        program = function()
          dotnet_build()
          return pick_dll()
        end,
        cwd = function()
          return vim.fn.getcwd()
        end,
        stopAtEntry = false,
        justMyCode = true,
        env = {
          ASPNETCORE_ENVIRONMENT = 'Development',
          DOTNET_ENVIRONMENT = 'Development',
        },
        args = function()
          local a = vim.fn.input 'Args (space-separated): '
          return (a == '' and {}) or vim.split(a, '%s+')
        end,
      },
      {
        type = 'coreclr',
        request = 'attach',
        name = 'Attach to process',
        processId = require('dap.utils').pick_process,
      },
    }
  end,
}
