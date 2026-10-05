-- filetypes
vim.filetype.add({
  extension = {
    hurl = "hurl",
  },
  filename = {
    ["requirements-dev.txt"] = "requirements",
    ["requirements_dev.txt"] = "requirements",
    ["condarc"] = "yaml",
    [".Renviron"] = "dosini",
    [".Rprofile"] = "r",
    [".env"] = "dosini",
  },
  pattern = {
    [".env.*"] = "dosini",
  },
})
