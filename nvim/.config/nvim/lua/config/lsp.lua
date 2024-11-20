-- LSP configuration
local utils = require("config.utils")

-- LSP diagnosis
local icons = require("config.icons")
local txt = {
  [vim.diagnostic.severity.ERROR] = icons.diagnosis.error,
  [vim.diagnostic.severity.WARN] = icons.diagnosis.warn,
  [vim.diagnostic.severity.INFO] = icons.diagnosis.info,
  [vim.diagnostic.severity.HINT] = icons.diagnosis.hint,
}

vim.diagnostic.config({
  virtual_text = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = { text = txt },
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
  },
})

-- start LSP servers
local lsp_group = vim.api.nvim_create_augroup("lsp_group", {})

--- @class LspClientConfig : vim.lsp.ClientConfig
--- @field filetypes string[]
--- @field markers? string[]
--- @field disable? boolean
--- @field root_dir_fallback? string

--- @param cfg LspClientConfig
local function config(cfg)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = cfg.filetypes,
    group = lsp_group,
    callback = function(args)
      local bufnr = args.buf
      if cfg.disable then
        return
      end
      if vim.bo[bufnr].buftype == "nofile" then
        return
      end

      if vim.fn.executable(cfg.cmd[1]) == 0 then
        return
      end

      cfg.markers = cfg.markers or {}
      table.insert(cfg.markers, ".git")
      cfg.root_dir = vim.fs.root(bufnr, cfg.markers) or cfg.root_dir_fallback

      -- vim.print("Attaching LSP " .. cfg.name)
      vim.lsp.start(cfg)
    end,
  })
end

local python_markers = {
  -- "setup.py",
  -- "setup.cfg",
  "requirements.txt",
  "pyproject.toml",
  "pyrightconfig.json",
  "Pipfile",
}

config({
  name = "pyright",
  disable = true,
  cmd = { utils.app_prio("pyright-langserver"), "--stdio" },
  filetypes = { "python" },
  single_file_support = true,
  markers = python_markers,
  root_dir_fallback = vim.env.PWD,
  settings = {
    pyright = {
      -- use Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        -- set to "openFilesOnly" if pyright is slow or if the virtual environment is large
        -- alternatively, try to comment "venv" and "venvPath" in pyproject.toml in section [tools.pyright]
        diagnosticMode = "workspace",
        typeCheckingMode = "strict",
        -- ignore all files for analysis to exclusively use Ruff for linting, and mypy for type checking if in use
        ignore = { "*" },
      },
      venvPath = vim.env.VIRTUAL_ENV,
    },
  },
})

config({
  name = "ruff",
  disable = false,
  cmd = { utils.app_prio("ruff"), "server" },
  filetypes = { "python" },
  markers = python_markers,
  root_dir_fallback = vim.env.PWD,
  -- enable ruff logging
  cmd_env = { RUFF_TRACE = "messages" },
  init_options = {
    settings = { logLevel = "error" },
  },
  -- disable ruff as hover provider to avoid conflicts with pyright
  on_attach = function(client)
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
})

config({
  name = "basedpyright",
  disable = false,
  cmd = { utils.app_prio("basedpyright-langserver"), "--stdio" },
  filetypes = { "python" },
  single_file_support = true,
  markers = python_markers,
  root_dir_fallback = vim.env.PWD,
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "workspace",
        typeCheckingMode = "all",
        -- ignore all files for analysis to exclusively use Ruff for linting, and mypy for type checking if in use
        ignore = { "*" },
      },
      disableOrganizeImports = true, --ruff formats imports
    },
    python = {
      venvPath = vim.env.VIRTUAL_ENV,
    },
  },
})

config({
  name = "r_language_server",
  disable = false,
  cmd = { utils.app_prio("r-languageserver") },
  filetypes = { "r", "rmd" },
  root_dir_fallback = vim.env.PWD,
})

config({
  name = "lua_ls",
  disable = false,
  cmd = { utils.app_prio("lua-language-server") },
  filetypes = { "lua" },
  single_file_support = true,
  markers = {
    ".luarc.json",
  },
  root_dir_fallback = vim.env.VIMRUNTIME,
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = "Disable",
        library = {
          vim.api.nvim_get_runtime_file("", true),
          "${3rd}/luv/library",
        },
      },
      diagnostics = {
        disable = { "missing-fields" },
        globals = { "vim", "utils", "icons" },
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
        setType = true,
        arrayIndex = "Disable",
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
})

config({
  name = "yamlls",
  disable = false,
  cmd = { utils.app_prio("yaml-language-server"), "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_dir_fallback = vim.env.PWD,
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    hover = true,
    completion = true,
    validate = true,
  },
})

config({
  name = "dockerls",
  disable = false,
  cmd = { utils.app_prio("docker-langserver"), "--stdio" },
  filetypes = { "dockerfile" },
  root_dir_fallback = vim.env.PWD,
})

config({
  name = "taplo",
  disable = false,
  cmd = { utils.app_prio("taplo"), "lsp", "stdio" },
  markers = {
    ".toml",
  },
  filetypes = { "toml" },
  root_dir_fallback = vim.env.PWD,
})

config({
  name = "bashls",
  disable = false,
  cmd = { utils.app_prio("bash-language-server"), "start" },
  filetypes = { "sh", "bash" },
  root_dir_fallback = vim.env.PWD,
  settings = {
    bashIde = {
      enableSourceErrorDiagnostics = true,
      shellcheckArguments = {
        "-e",
        "SC2086",
        "-e",
        "SC2155",
      },
    },
  },
})

config({
  name = "sqlls",
  disable = false,
  cmd = { utils.app_prio("sql-language-server"), "up", "--method", "stdio" },
  filetypes = { "sql", "mysql" },
  root_dir_fallback = vim.env.PWD,
  settings = {},
})

config({
  name = "marksman",
  disable = false,
  cmd = { utils.app_prio("marksman"), "server" },
  filetypes = { "markdown" },
  root_dir_fallback = vim.env.PWD,
  settings = {},
})

config({
  name = "jsonls",
  disable = true,
  cmd = { utils.app_prio("vscode-json-language-server"), "--stdio" },
  filetypes = { "json", "jsonc" },
  root_dir_fallback = vim.env.PWD,
  settings = {
    init_options = {
      provideFormatter = true,
    },
  },
})

-- LSP keymaps
local opts = { noremap = true, silent = true }

vim.keymap.set(
  "n",
  "<leader>dd",
  vim.diagnostic.open_float,
  vim.tbl_extend("error", opts, { desc = "Display LSP diagnostic message in open float window" })
)
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setqflist,
  vim.tbl_extend("error", opts, { desc = "Move all LSP diagnostic messages into a quickfix window" })
)
vim.keymap.set("n", "[d", function()
  vim.diagnostic.goto_prev({ float = false })
  vim.cmd([[normal! zz]])
end, vim.tbl_extend("error", opts, { desc = "Go to previous LSP diagnostic message" }))
vim.keymap.set("n", "]d", function()
  vim.diagnostic.goto_next({ float = false })
  vim.cmd([[normal! zz]])
end, vim.tbl_extend("error", opts, { desc = "Go to next LSP diagnostic message" }))

-- LSP attach autocommand
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps_config", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      -- enable completion triggered by <c-x><c-o>
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    -- buffer local mappings
    -- see `:help vim.lsp.*` for documentation on any of the below functions

    -- unmap in Nvim 0.11 (make sure go-replace-line using grr works after unmap)
    -- vim.keymap.del("n", "grn", { buffer = bufnr, desc = "Unmap Neovim default LSP keybind" })
    -- vim.keymap.del("n", "grr", { buffer = bufnr, desc = "Unmap Neovim default LSP keybind" })
    -- vim.keymap.del({ "n", "x" }, "gra", { buffer = bufnr, desc = "Unmap Neovim default LSP keybind" })
    -- vim.keymap.del("i", "<c-s>", { buffer = bufnr, desc = "Unmap Neovim default LSP keybind" })

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_declaration) then
      vim.keymap.set(
        "n",
        "gD",
        vim.lsp.buf.declaration,
        vim.tbl_extend("error", bufopts, { desc = "Jump to the declaration of the LSP symbol" })
      )
    end

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
      vim.keymap.set(
        "n",
        "gd",
        require("telescope.builtin").lsp_definitions,
        -- vim.lsp.buf.definition()
        -- vim.cmd([[normal! zt]])
        vim.tbl_extend("error", bufopts, { desc = "Jump to the definition of the LSP symbol" })
      )
    end

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_references) then
      vim.keymap.set(
        "n",
        "gh",
        function()
          require("telescope.builtin").lsp_references({
            include_declaration = false,
            include_current_line = true,
          })
        end,
        -- vim.lsp.buf.references,
        vim.tbl_extend("error", bufopts, { desc = "Lists all the references to the LSP symbol in telescope" })
      )
    end

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
      vim.keymap.set(
        "n",
        "gi",
        require("telescope.builtin").lsp_implementations,
        -- vim.lsp.buf.implementation,
        vim.tbl_extend("error", bufopts, { desc = "Show implementation for the LSP symbol in telescope" })
      )
    end

    vim.keymap.set(
      "i",
      "<c-k>",
      vim.lsp.buf.signature_help,
      vim.tbl_extend(
        "error",
        bufopts,
        { desc = "Display signature information for the LSP symbol in a floating window (insert mode)" }
      )
    )

    vim.keymap.set(
      "n",
      "K",
      vim.lsp.buf.hover,
      vim.tbl_extend("error", bufopts, { desc = "Display help window for the LSP symbol as a hover window" })
    )

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
      vim.keymap.set(
        "n",
        "gt",
        require("telescope.builtin").lsp_type_definitions,
        -- vim.lsp.buf.type_definition,
        vim.tbl_extend("error", bufopts, { desc = "Show type definition for the LSP symbol in telescope" })
      )
    end

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
      vim.keymap.set(
        "n",
        "<leader>rn",
        -- vim.lsp.buf.rename,
        -- vim.tbl_extend("error", bufopts, { desc = "Rename symbol using LSP" })
        function()
          return ":IncRename "
        end,
        vim.tbl_extend("error", bufopts, { expr = true, desc = "Rename symbol using inc-rename" })
      )
    end

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
      vim.keymap.set(
        { "n", "v" },
        "<leader>ca",
        vim.lsp.buf.code_action,
        vim.tbl_extend("error", bufopts, { desc = "Display code actions using LSP" })
      )
    end

    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
      end, vim.tbl_extend("error", bufopts, { desc = "Toggle inlay hints" }))
    end

    -- highlight/clear references of the word under your cursor
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp_highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp_detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp_highlight", buffer = event2.buf })
        end,
      })
    end
  end,
})
