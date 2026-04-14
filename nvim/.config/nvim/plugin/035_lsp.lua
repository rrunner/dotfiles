-- lsp

-- enable LSP servers
vim.lsp.enable({
  "bashls",
  "dockerls",
  "expert",
  "harper_ls",
  "jsonls",
  "lua_ls",
  "ruff",
  "sqlls",
  "tombi",
  "ty",
  "yamlls",
})

-- diagnostic
vim.diagnostic.config({
  virtual_text = {
    current_line = true,
    severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
    prefix = Config.icons.diagnosis.square,
  },
  virtual_lines = false,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = Config.icons.diagnosis.error,
      [vim.diagnostic.severity.WARN] = Config.icons.diagnosis.warn,
      [vim.diagnostic.severity.INFO] = Config.icons.diagnosis.info,
      [vim.diagnostic.severity.HINT] = Config.icons.diagnosis.hint,
    },
  },
  float = {
    source = true,
    header = "",
    prefix = "",
  },
})

-- LSP keymaps
local map = function(mode, lhs, rhs, opts)
  local default_opts = { noremap = true, silent = true }
  opts = vim.tbl_extend("keep", opts, default_opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local jump = function(cnt)
  Config.utils.run_wo_snacks_scroll(function()
    vim.diagnostic.jump({ count = cnt, float = true })
    vim.cmd([[normal! zz]])
  end)
end

map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Display diagnostics in open float window" })
map("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Display diagnostics in a quickfix window" })
map("n", "[d", function()
  jump(-1)
end, { desc = "Go to previous diagnostic message (without scroll)" })
map("n", "]d", function()
  jump(1)
end, { desc = "Go to next diagnostic message (without scroll)" })

-- LSP attach autocommand
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LSPConfig", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local exists_snacks, snacks = pcall(require, "snacks")

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      -- enable completion triggered by <c-x><c-o>
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    -- use gq to format with LSP (use gw to use internal formatting)
    vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr"
    -- vim.bo[bufnr].formatexpr = nil  -- use internal formatting with gq

    -- buffer local keymaps/autocommands (override default keymaps to use snacks picker in most cases)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_declaration) then
      map("n", "gD", function()
        if exists_snacks then
          snacks.picker.lsp_declarations()
        else
          vim.lsp.buf.declaration()
        end
      end, { buf = bufnr, desc = "LSP declaration" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
      map("n", "gd", function()
        if exists_snacks then
          snacks.picker.lsp_definitions()
        else
          vim.lsp.buf.definition()
        end
      end, { buf = bufnr, desc = "LSP definition" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_references) then
      map("n", "grr", function()
        if exists_snacks then
          snacks.picker.lsp_references()
        else
          vim.lsp.buf.references()
        end
      end, { buf = bufnr, nowait = true, desc = "LSP references" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
      map("n", "gri", function()
        if exists_snacks then
          snacks.picker.lsp_implementations()
        else
          vim.lsp.buf.implementation()
        end
      end, { buf = bufnr, desc = "LSP implementation" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
      map("n", "gO", vim.lsp.buf.document_symbol, { buf = bufnr, desc = "LSP document symbol" })
    end

    -- use blink's signature help with below fallback
    map("i", "<c-s>", function()
      local exists_blink, _ = pcall(require, "blink.cmp")
      if not exists_blink then
        vim.lsp.buf.signature_help()
      end
    end, { buf = bufnr, desc = "LSP function signature (insert mode)" })

    map("n", "K", function()
      vim.lsp.buf.hover({ width = 80, height = 20 })
    end, { buf = bufnr, desc = "LSP hover window" })

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
      map("n", "grt", function()
        if exists_snacks then
          snacks.picker.lsp_type_definitions()
        else
          vim.lsp.buf.type_definition()
        end
      end, { buf = bufnr, desc = "LSP type definitions" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
      map("n", "grn", vim.lsp.buf.rename, { buf = bufnr, desc = "Rename LSP symbol" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
      map({ "n", "x" }, "gra", vim.lsp.buf.code_action, { buf = bufnr, desc = "LSP code actions" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, { buf = bufnr, desc = "Toggle inlay hints" })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_group = vim.api.nvim_create_augroup("LSPHighlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "InsertLeave" }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
        desc = "Highlight references under the cursor",
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
        desc = "Clear highlight references",
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
      map("n", "<leader>cl", function()
        vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
      end, { buf = bufnr, desc = "Toggle code lens" })
    end
  end,
})
