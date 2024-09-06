-- indentation marker and indentaition textobjects
return {
  "echasnovski/mini.indentscope",
  event = { "BufReadPost", "BufNewFile" },
  version = false,
  config = function()
    local mini_indentscope = require("mini.indentscope")
    local opts = {
      draw = {
        delay = 50,
        animation = mini_indentscope.gen_animation.none(),
      },
      mappings = {
        -- textobjects
        object_scope = "ii",
        object_scope_with_border = "ai",
        goto_top = "", -- "[i"
        goto_bottom = "", -- "]i"
      },
      options = {
        -- type of scope's border: 'both', 'top', 'bottom', 'none'
        border = "top",
      },
      symbol = "┊",
    }
    mini_indentscope.setup(opts)

    -- disable for certain filetypes
    vim.api.nvim_create_autocmd({ "FileType" }, {
      desc = "Disable indentscope for certain filetypes",
      callback = function()
        local ignore_filetypes = {
          "",
          "aerial",
          "checkhealth",
          "gitcommit",
          "help",
          "lazy",
          "lspinfo",
          "man",
          "mason",
          "neo-tree",
          "noice",
          "notify",
          "qf",
          "text",
          "toggleterm",
          "DressingInput",
          "DressingSelect",
          "TelescopePrompt",
          "TelescopeResults",
        }
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
          vim.b.miniindentscope_disable = true
        end
      end,
    })
  end,
}
