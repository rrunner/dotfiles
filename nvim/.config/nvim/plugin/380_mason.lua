-- mason
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

--- Auto-install tools such as LSP, debuggers and linters that are not already
--- installed. Does not update already-installed packages. Use :Mason command
--- to update installed tools instead.
--- @param tools string[] -- tools to install
local install_tools = function(tools)
  local registry = require("mason-registry")
  registry.update(function(success)
    if not success then
      vim.schedule(function()
        vim.notify("Failed to update Mason registries", vim.log.levels.ERROR)
      end)
      return
    end
    local installed_tools = registry.get_installed_package_names()
    vim.iter(tools):each(function(tool)
      if not vim.tbl_contains(installed_tools, tool) then
        local found_pkg, pkg = pcall(registry.get_package, tool)
        if not found_pkg then
          vim.notify(tool .. " not found in Mason registries", vim.log.levels.ERROR)
        else
          pkg:install({}, function(success_install)
            vim.schedule(function()
              if success_install then
                vim.notify(tool .. " installed", vim.log.levels.INFO)
              else
                vim.notify(tool .. " failed to install", vim.log.levels.ERROR)
              end
            end)
          end)
        end
      end
    end)
  end)
end

vim.pack.add({
  { src = "https://github.com/mason-org/mason.nvim" },
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

if vim.g.is_github_not_blocked and Config.utils.should_run_daily("mason_daily_install") then
  vim.notify("Check for Mason tools", vim.log.levels.INFO)
  local ensure_installed = Config.utils.unique_values(lsp_servers, tools)
  install_tools(ensure_installed)
  Config.utils.mark_daily_run("mason_daily_install")
end
