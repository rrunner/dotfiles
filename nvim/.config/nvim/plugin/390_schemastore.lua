-- schemastore (SchemaStore catalog for use with jsonls and yamlls)
if not vim.g.is_github_not_blocked then
  return
end

vim.pack.add({ "https://github.com/b0o/SchemaStore.nvim" })
-- loaded by jsonls and yamlls LSP configurations
