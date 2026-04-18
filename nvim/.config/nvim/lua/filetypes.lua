-- filetypes
vim.filetype.add({
  extension = {
    hurl = "hurl",
  },
  filename = {
    ["requirements-dev.txt"] = "requirements",
    ["requirements_dev.txt"] = "requirements",
    ["condarc"] = "yaml",
    [".Renviron"] = "sh",
    [".Rprofile"] = "r",
  },
})
