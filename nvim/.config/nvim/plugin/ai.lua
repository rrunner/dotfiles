-- ai (around/inner and text-objects)
local mini_ai = require("mini.ai")
local spec_treesitter = mini_ai.gen_spec.treesitter

mini_ai.setup({
  custom_textobjects = {
    -- function definition (af/if)
    f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),

    -- class definition (ac/ic)
    c = spec_treesitter({ a = "@class.outer", i = "@class.inner" }),

    -- parameter/argument: consider to use [","] = ...  to avoid conflict with built-in 'a' (argument)
    a = spec_treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),

    -- block + conditional + loop combined (ao/io)
    o = spec_treesitter({
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
  },
  mappings = {
    -- main textobject prefixes
    around = "a",
    inside = "i",

    -- next/last variants
    -- note: these override built-in lsp selection mappings on neovim>=0.12
    -- map lsp selection manually to use it (see `:h miniai.config`)
    around_next = "an",
    inside_next = "in",
    around_last = "al",
    inside_last = "il",

    -- move cursor to corresponding edge of `a` textobject
    goto_left = "",
    goto_right = "",
  },
})

local map_lsp_selection = function(lhs, desc)
  local s = vim.startswith(desc, "Increase") and 1 or -1
  local rhs = function()
    vim.lsp.buf.selection_range(s * vim.v.count1)
  end
  vim.keymap.set("x", lhs, rhs, { desc = desc })
end
map_lsp_selection("<c-a>", "Increase selection")
map_lsp_selection("<c-x>", "Decrease selection")

local function jump(side, search_method, id)
  mini_ai.move_cursor(side, "a", id, { search_method = search_method })
end

vim.keymap.set({ "n", "x", "o" }, "]f", function()
  jump("left", "next", "f")
end, { desc = "Jump to next function start (mini.ai)" })

vim.keymap.set({ "n", "x", "o" }, "[f", function()
  jump("left", "prev", "f")
end, { desc = "Jump to prev function start (mini.ai)" })
