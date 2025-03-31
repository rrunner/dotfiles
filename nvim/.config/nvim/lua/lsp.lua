local icons = require("config.icons")

-- LSP enable servers
vim.lsp.enable({
  "basedpyright",
  "bashls",
  "dockerls",
  "jsonls",
  "lua_ls",
  "marksman",
  "r_language_server",
  "ruff",
  "sqlls",
  "taplo",
  "yamlls",
})

-- LSP diagnosis
vim.diagnostic.config({
  virtual_text = false,
  -- virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnosis.error,
      [vim.diagnostic.severity.WARN] = icons.diagnosis.warn,
      [vim.diagnostic.severity.INFO] = icons.diagnosis.info,
      [vim.diagnostic.severity.HINT] = icons.diagnosis.hint,
    },
  },
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
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
  vim.diagnostic.jump({ count = -1, float = true })
  vim.cmd([[normal! zz]])
end, vim.tbl_extend("error", opts, { desc = "Go to previous LSP diagnostic message" }))
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
  vim.cmd([[normal! zz]])
end, vim.tbl_extend("error", opts, { desc = "Go to next LSP diagnostic message" }))

-- LSP attach autocommand
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_keymaps_config", { clear = true }),
  callback = function(event)
    local bufnr = event.buf
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      -- enable completion triggered by <c-x><c-o>
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
      vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
    end

    -- buffer local mappings
    -- see `:help vim.lsp.*` for documentation on any of the below functions

    -- unmap in Nvim 0.11 (make sure go-replace-line using grr works after unmap)
    -- vim.keymap.del("n", "grn", { buffer = bufnr, desc = "Unmap Neovim default LSP keybind" })
    -- vim.keymap.del("n", "grr", { buffer = bufnr, desc = "Unmap Neovim default LSP keybind" })
    -- vim.keymap.del({ "n", "x" }, "gra", { buffer = bufnr, desc = "Unmap Neovim default LSP keybind" })
    -- vim.keymap.del("i", "<c-s>", { buffer = bufnr, desc = "Unmap Neovim default LSP keybind" })

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_declaration) then
      vim.keymap.set(
        "n",
        "gD",
        vim.lsp.buf.declaration,
        vim.tbl_extend("error", bufopts, { desc = "Jump to the declaration of the LSP symbol" })
      )
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_definition) then
      vim.keymap.set("n", "gd", function()
        Snacks.picker.lsp_definitions()
      end, {
        noremap = true,
        silent = true,
        desc = "LSP definition",
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_references) then
      vim.keymap.set("n", "gh", function()
        Snacks.picker.lsp_references()
      end, {
        noremap = true,
        silent = true,
        desc = "LSP references",
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_implementation) then
      vim.keymap.set("n", "gi", function()
        Snacks.picker.lsp_implementations()
      end, {
        noremap = true,
        silent = true,
        desc = "LSP implementation",
      })
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

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_typeDefinition) then
      vim.keymap.set("n", "gt", function()
        Snacks.picker.lsp_type_definitions()
      end, {
        noremap = true,
        silent = true,
        desc = "LSP type definitions",
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_rename) then
      vim.keymap.set(
        "n",
        "<leader>rn",
        vim.lsp.buf.rename,
        vim.tbl_extend("error", bufopts, { desc = "Rename symbol using LSP" })
      )
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeAction) then
      vim.keymap.set(
        { "n", "v" },
        "<leader>ca",
        vim.lsp.buf.code_action,
        vim.tbl_extend("error", bufopts, { desc = "Display code actions using LSP" })
      )
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      vim.keymap.set("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
      end, vim.tbl_extend("error", bufopts, { desc = "Toggle inlay hints" }))
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_foldingRange) then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = "expr"
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp_detach_folds", { clear = true }),
        command = "setlocal foldexpr<",
      })
    end

    -- highlight/clear references of the word under your cursor
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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
