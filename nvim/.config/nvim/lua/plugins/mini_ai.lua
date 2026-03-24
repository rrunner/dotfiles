return {
  "nvim-mini/mini.ai",
  version = false,
  config = function()
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
    })

    local function jump(side, search_method, id)
      mini_ai.move_cursor(side, "a", id, { search_method = search_method })
    end

    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      jump("left", "next", "f")
    end, { desc = "Jump to next function start (mini.ai)" })

    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      jump("left", "prev", "f")
    end, { desc = "Jump to prev function start (mini.ai)" })
  end,
}
