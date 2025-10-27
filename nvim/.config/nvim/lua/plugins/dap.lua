-- dap configuration
return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    {
      "<leader>db",
      [[<cmd>lua require('dap').toggle_breakpoint()<cr>]],
      mode = "n",
      desc = "Toggle breakpoint (debugger)",
      noremap = true,
      silent = true,
    },
    {
      "<leader>dk",
      function()
        local prompt = "Conditional breakpoint: "
        vim.ui.input({ prompt = prompt }, function(condition)
          if condition == nil or condition == "" then
            return
          end
          vim.notify(prompt .. condition, vim.log.levels.INFO)
          require("dap").set_breakpoint(condition, nil, nil)
        end)
      end,
      mode = "n",
      desc = "Set conditional breakpoint (debugger)",
      noremap = true,
      silent = true,
    },
    {
      "<leader>dc",
      [[<cmd>lua require('dap').continue()<cr>]],
      mode = "n",
      desc = "Start/continue (debugger)",
      noremap = true,
      silent = true,
    },
  },
  config = function()
    local utils = require("config.utils")
    local icons = require("config.icons")

    -- symbols
    vim.fn.sign_define("DapBreakpoint", { text = icons.dap.breakpoint, texthl = "DapUIStop", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = icons.dap.logpoint, texthl = "DapUIStop", linehl = "", numhl = "" })
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = icons.dap.condition, texthl = "SignColumn", linehl = "", numhl = "" }
    ) -- text default: C
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = icons.dap.rejected, texthl = "SignColumn", linehl = "", numhl = "" }
    ) -- text default: R
    vim.fn.sign_define("DapStopped", {
      text = icons.dap.stopped,
      texthl = "DapUIPlayPause",
      linehl = "",
      numhl = "",
    })

    vim.keymap.set("n", "<leader>dr", [[<cmd>lua require('dapui').open({reset = true})<cr>]], {
      noremap = true,
      silent = true,
      desc = "Reset windows (debugger)",
    })

    vim.keymap.set("n", "<leader>dn", [[<cmd>lua require('dap').step_over()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Step over/next (debugger)",
    })

    vim.keymap.set("n", "<leader>di", [[<cmd>lua require('dap').step_into()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Step into (debugger)",
    })

    vim.keymap.set("n", "<leader>do", [[<cmd>lua require('dap').step_out()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Step out (debugger)",
    })

    vim.keymap.set("n", "<leader>dq", [[<cmd>lua require('dap').terminate(); require('dapui').close()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Terminate and close GUI (debugger)",
    })

    vim.keymap.set("n", "<leader>dl", function()
      local prompt = "Log point message: "
      vim.ui.input({ prompt = prompt }, function(message)
        if message == nil or message == "" then
          return
        end
        vim.notify(prompt .. message, vim.log.levels.INFO)
        require("dap").set_breakpoint(nil, nil, message)
      end)
    end, {
      noremap = true,
      silent = true,
      desc = "Set logpoint message (debugger)",
    })

    vim.keymap.set("x", "<leader>ds", function()
      local lines = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))
      if utils.is_debugger_running() then
        require("dap").repl.execute(table.concat(lines, "\n"))
      end
    end, {
      noremap = true,
      silent = true,
      desc = "Send lines to DAP REPL (debugger)",
    })

    -- load debugger
    local dap, dapui = require("dap"), require("dapui")

    -- set gui layout
    dapui.setup({
      mappings = {
        open = "<cr>",
        expand = "o",
      },
      element_mappings = {
        stacks = {
          open = { "<cr>" },
        },
      },
      layouts = {
        {
          position = "left",
          size = 40, -- 40 columns
          elements = {
            { id = "scopes", size = 0.4 },
            { id = "breakpoints", size = 0.1 },
            { id = "stacks", size = 0.3 },
            { id = "watches", size = 0.2 },
          },
        },
        {
          elements = { "repl" },
          size = 0.45,
          position = "bottom",
        },
        {
          elements = { "console" },
          size = 0.25,
          position = "right",
        },
      },
      controls = {
        enabled = true,
        elements = "repl",
      },
      icons = {
        collapsed = icons.chars.foldclose,
        current_frame = icons.chars.foldclose,
        expanded = icons.chars.foldopen,
      },
    })

    -- open and close dapui automatically in debugging mode (based on dap events)
    dap.listeners.after.event_initialized["dapui_config"] = function()
      -- close Snacks explorer picker and aerial windows when debugger opens
      utils.close_explorer_picker()
      local exists_aerial, cmd_aerial = pcall(require, "aerial")
      if exists_aerial then
        cmd_aerial.close_all()
      end
      dapui.open()
    end

    -- register the debugpy adapter on how to launch/attach
    dap.adapters.debugpy = function(callback, config)
      if config.request == "launch" then
        callback({
          type = "executable",
          command = utils.get_python_path(),
          args = { "-m", "debugpy.adapter" },
          options = {
            source_filetype = "python",
          },
        })
      elseif config.request == "attach" then
        local host = config.connect.host or "127.0.0.1"
        local port = config.connect.port
        callback({
          type = "server",
          host = host,
          port = assert(port, "`connect.port` is required for a python `attach` configuration"),
          options = {
            source_filetype = "python",
          },
        })
      end
    end
    -- workaround to debug tests using neotest-python (hardwired to adapter name "python")
    dap.adapters.python = dap.adapters.debugpy

    -- configure the python debugee (application)
    -- comments about some of the options:
    --  console = "integratedTerminal" - print to console (does not print to console when testing in debugging mode with neotest-python)
    --  console = "internalConsole" - print to REPL
    --  justMyCode = false - debug third party libraries
    --  subProcess = false - dap-adapter-debugpy does not support multiprocess yet (disable multiprocess patch in debugpy)
    --  cwd = "${workspaceFolder}" - use the current cwd of editor/buffer, not the file's absolute path
    --  stopOnEntry = false - stop at first line of user code
    dap.configurations.python = {
      {
        type = "debugpy",
        request = "launch",
        name = "Debug/launch current file",
        program = "${file}",
        console = "internalConsole",
        justMyCode = false,
        subProcess = false,
        cwd = "${workspaceFolder}",
        pythonPath = function()
          return utils.get_python_path()
        end,
        stopOnEntry = false,
      },
      -- {
      --   type = "debugpy",
      --   request = "launch",
      --   name = "Debug/launch current file with arguments",
      --   program = "${file}",
      --   console = "internalConsole",
      --   justMyCode = false,
      --   subProcess = false,
      --   args = function()
      --     local args_string = vim.fn.input("Arguments: ")
      --     return vim.split(args_string, " +")
      --   end,
      --   cwd = function()
      --     return vim.fn.getcwd()
      --   end,
      --   pythonPath = function()
      --     return utils.get_python_path()
      --   end,
      --   stopOnEntry = false,
      -- },
      -- {
      --   -- 1. open the debuggee (application or script to debug) from the folder where "venv" folder is located
      --   -- 2. ensure the cwd path is correct (pyproject.toml and src/app folders should all reside in the cwd),
      --   --    the cwd may be set in pyproject.toml (see package_name = "..." and project_name = "..." under [tool.kedro])
      --   -- 3. update args to fit the pipeline/node to be debugged
      --   type = "debugpy",
      --   request = "launch",
      --   name = "Debug/launch Kedro Run (stop on entry)",
      --   console = "integratedTerminal",
      --   justMyCode = false,
      --   subProcess = false,
      --   cwd = vim.env.HOME .. "/projects/python/kedro-environment/iris",
      --   module = "kedro",
      --   args = "run",
      --   -- args = { "run", "--pipeline", "pipeline_name", "--arg1", "value1", "--arg2", "value2" },
      --   pythonPath = function()
      --     return utils.get_python_path()
      --   end,
      --   stopOnEntry = true,
      -- },
      -- {
      --   -- send curl request to endpoints to debug
      --   type = "debugpy",
      --   request = "launch",
      --   name = "Debug FastAPI module",
      --   module = "uvicorn",
      --   args = {
      --     "main:app",
      --     "--reload", -- may not work
      --     -- "--port",
      --     -- "8000",
      --     -- "--use-colors",
      --   },
      --   jinja = false,
      --   env = { FastAPI_ENV = "development" },
      --   -- envFile = "${workspaceFolder}/src/.env",
      --   console = "integratedTerminal",
      --   pythonPath = function()
      --     return utils.get_python_path()
      --   end,
      --   stopOnEntry = true,
      -- },
      -- {
      --   type = "debugpy",
      --   request = "launch",
      --   name = "Debug FastAPI main",
      --   program = function()
      --     return "./main.py"
      --   end,
      --   pythonPath = function()
      --     return utils.get_python_path()
      --   end,
      -- },
      -- {
      --   type = "debugpy",
      --   request = "attach",
      --   name = "Attach a debugging session",
      --   connect = function()
      --     local host = vim.fn.input("Host: ")
      --     local port = tonumber(vim.fn.input("Port: "))
      --     return { host = host, port = port }
      --   end,
      -- },
    }
  end,
}
