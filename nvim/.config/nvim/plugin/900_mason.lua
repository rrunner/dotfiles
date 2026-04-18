-- mason
if not vim.g.is_github_not_blocked then
  return
end

local mason_group = vim.api.nvim_create_augroup("MasonConfig", { clear = true })

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if name == "mason.nvim" and kind == "update" then
      if not event.data.active then
        vim.cmd.packadd("mason.nvim")
      end
      vim.cmd("MasonUpdate")
    end
  end,
  group = mason_group,
  pattern = "*",
  desc = "Post-update hook to update Mason registries",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    if vim.tbl_contains({ "mason" }, vim.bo[event.buf].filetype) then
      vim.wo.cursorline = false
    end
  end,
  group = mason_group,
  pattern = "*",
  desc = "Disable cursorline for Mason",
})

require("mason").setup({
  ui = {
    width = 0.8,
    height = 0.9,
    border = "none",
    keymaps = {
      toggle_package_expand = "o",
      toggle_package_install_log = "o",
    },
  },
})

-- mason-tool-installer (to automatically install tools if not already installed)
local lsp_servers = {
  "bash-language-server", --bashls
  "dockerfile-language-server", --dockerls
  "expert",
  "harper-ls", --harper_ls
  "json-lsp",
  "lua-language-server", --lua_ls
  "ruff",
  "sqlls",
  "tombi",
  "ty",
  "yaml-language-server", --yamlls
}

local tools = {
  "air",
  "debugpy",
  "hlint",
  "jq",
  "markdown-toc",
  "markdownlint-cli2",
  "ormolu",
  "prettier",
  "ruff",
  "shfmt",
  "sql-formatter",
  "sqlfluff",
  "stylua",
}

local ensure_installed = Config.utils.unique_values(lsp_servers, tools)
require("mason-tool-installer").setup({
  debounce_hours = 24,
  ensure_installed = ensure_installed,
})
