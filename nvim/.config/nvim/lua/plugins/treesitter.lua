-- treesitter (core functionality and main plugin dependency)
local ts_group = vim.api.nvim_create_augroup("TSConfig", { clear = true })

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not event.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
  group = ts_group,
  pattern = "*",
  desc = "Update TS parsers after nvim-treesitter is updated",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    local bufnr = args.buf
    -- treesitter is not available if there is no filetype
    if vim.bo[bufnr].filetype == "" then
      return
    end
    -- no parser available
    if not pcall(vim.treesitter.get_parser, bufnr) then
      return
    end
    -- highlighting
    if not pcall(vim.treesitter.start, bufnr) then
      return
    end
    -- indentation
    if pcall(require, "nvim-treesitter") then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
    -- folds
    local winid = vim.fn.bufwinid(bufnr)
    vim.wo[winid][0].foldmethod = "expr"
    vim.wo[winid][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end,
  group = ts_group,
  pattern = "*",
  desc = "Enable TS highlighting, indentation and folding",
})

local ts_parsers = {
  "bash",
  "bibtex",
  "c",
  "csv",
  "diff",
  "dockerfile",
  "editorconfig",
  "eex",
  "elixir",
  "git_config",
  "git_rebase",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "haskell",
  "heex",
  "html",
  "http",
  "hurl",
  "json",
  "json5",
  "julia",
  "latex",
  "lua",
  "luadoc",
  "luap",
  "luau",
  "markdown",
  "markdown_inline",
  "matlab",
  "mermaid",
  "nu",
  "printf",
  "psv",
  "python",
  "query",
  "r",
  "regex",
  "requirements",
  "rst",
  "sql",
  "terraform",
  "toml",
  "tsv",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

-- install TS parsers
local already_installed = require("nvim-treesitter.config").get_installed("parsers")
local parsers_to_install = vim
  .iter(ts_parsers)
  :filter(function(parser)
    return not vim.tbl_contains(already_installed, parser)
  end)
  :totable()
require("nvim-treesitter").install(parsers_to_install, { summary = true })

-- use specific TS parsers for some filetypes
for ft, lang in pairs({
  git = "diff",
  quarto = "markdown",
  rmd = "markdown",
  livebook = "markdown",
}) do
  vim.treesitter.language.register(lang, ft)
end

-- TS textobjects (around/inner selection and movement via nvim-treesitter-textobjects)
local select = require("nvim-treesitter-textobjects.select")
local move = require("nvim-treesitter-textobjects.move")

require("nvim-treesitter-textobjects").setup({
  select = {
    lookahead = true,
    selection_modes = {
      ["@function.outer"] = "V",
      ["@class.outer"] = "V",
    },
    include_surrounding_whitespace = false,
  },
  move = {
    set_jumps = true,
  },
})

-- select keymaps

-- function
vim.keymap.set({ "x", "o" }, "af", function()
  select.select_textobject("@function.outer", "textobjects")
end, { desc = "Select around function" })
vim.keymap.set({ "x", "o" }, "if", function()
  select.select_textobject("@function.inner", "textobjects")
end, { desc = "Select inside function" })
-- class
vim.keymap.set({ "x", "o" }, "ac", function()
  select.select_textobject("@class.outer", "textobjects")
end, { desc = "Select around class" })
vim.keymap.set({ "x", "o" }, "ic", function()
  select.select_textobject("@class.inner", "textobjects")
end, { desc = "Select inside class" })
-- parameter/argument
vim.keymap.set({ "x", "o" }, "aa", function()
  select.select_textobject("@parameter.outer", "textobjects")
end, { desc = "Select around argument" })
vim.keymap.set({ "x", "o" }, "ia", function()
  select.select_textobject("@parameter.inner", "textobjects")
end, { desc = "Select inside argument" })
-- block / conditional / loop
vim.keymap.set({ "x", "o" }, "ao", function()
  select.select_textobject("@block.outer", "textobjects")
end, { desc = "Select around block" })
vim.keymap.set({ "x", "o" }, "io", function()
  select.select_textobject("@block.inner", "textobjects")
end, { desc = "Select inside block" })

-- move keymaps
-- function
vim.keymap.set({ "n", "x", "o" }, "]f", function()
  move.goto_next_start("@function.outer", "textobjects")
end, { desc = "Next function start" })
vim.keymap.set({ "n", "x", "o" }, "]F", function()
  move.goto_next_end("@function.outer", "textobjects")
end, { desc = "Next function end" })
vim.keymap.set({ "n", "x", "o" }, "[f", function()
  move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "Prev function start" })
vim.keymap.set({ "n", "x", "o" }, "[F", function()
  move.goto_previous_end("@function.outer", "textobjects")
end, { desc = "Prev function end" })
-- class
vim.keymap.set({ "n", "x", "o" }, "]c", function()
  move.goto_next_start("@class.outer", "textobjects")
end, { desc = "Next class start" })
vim.keymap.set({ "n", "x", "o" }, "]C", function()
  move.goto_next_end("@class.outer", "textobjects")
end, { desc = "Next class end" })
vim.keymap.set({ "n", "x", "o" }, "[c", function()
  move.goto_previous_start("@class.outer", "textobjects")
end, { desc = "Prev class start" })
vim.keymap.set({ "n", "x", "o" }, "[C", function()
  move.goto_previous_end("@class.outer", "textobjects")
end, { desc = "Prev class end" })
-- parameter/argument
vim.keymap.set({ "n", "x", "o" }, "]a", function()
  move.goto_next_start("@parameter.outer", "textobjects")
end, { desc = "Next argument start" })
vim.keymap.set({ "n", "x", "o" }, "]A", function()
  move.goto_next_end("@parameter.outer", "textobjects")
end, { desc = "Next argument end" })
vim.keymap.set({ "n", "x", "o" }, "[a", function()
  move.goto_previous_start("@parameter.outer", "textobjects")
end, { desc = "Prev argument start" })
vim.keymap.set({ "n", "x", "o" }, "[A", function()
  move.goto_previous_end("@parameter.outer", "textobjects")
end, { desc = "Prev argument end" })
-- block / conditional / loop
vim.keymap.set({ "n", "x", "o" }, "]o", function()
  move.goto_next_start("@block.outer", "textobjects")
end, { desc = "Next block start" })
vim.keymap.set({ "n", "x", "o" }, "]O", function()
  move.goto_next_end("@block.outer", "textobjects")
end, { desc = "Next block end" })
vim.keymap.set({ "n", "x", "o" }, "[o", function()
  move.goto_previous_start("@block.outer", "textobjects")
end, { desc = "Prev block start" })
vim.keymap.set({ "n", "x", "o" }, "[O", function()
  move.goto_previous_end("@block.outer", "textobjects")
end, { desc = "Prev block end" })

-- incremental treesitter selection on <c-a> / <c-x> (remap to built-in an/in)
vim.keymap.set("x", "<c-a>", "an", { remap = true, desc = "Increase treesitter node selection" })
vim.keymap.set("x", "<c-x>", "in", { remap = true, desc = "Decrease treesitter node selection" })

-- disable entire built-in ftplugin mappings to avoid conflicts (plugin nvim-treesitter-textobjects)
vim.g.no_plugin_maps = true

-- TS context
require("treesitter-context").setup({
  multiline_threshold = 1,
})
