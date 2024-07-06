return {
  "stevearc/qf_helper.nvim",
  enabled = false,
  ft = "qf",
  init = function()
    -- any active quickfix or location list among buffers in the buffer list
    P = {}
    P.qf_helper_keys_mapped = false
    P.any_active_qfll = function()
      local res = {}
      local wininfo = vim.fn.getwininfo()
      for _, dic in ipairs(wininfo) do
        if dic["quickfix"] == 1 then
          table.insert(res, 1, true)
          table.insert(res, 2, dic["bufnr"])
          return res
        end
      end
      table.insert(res, 1, false)
      table.insert(res, 2, nil)
      return res
    end
    return P
  end,
  config = function()
    local qf_helper = vim.api.nvim_create_augroup("Plugins", { clear = true })

    -- set or unmap keybinding related to presence of active quickfix/location list
    vim.api.nvim_create_autocmd({ "QuickFixCmdPost", "BufWinEnter", "BufNew", "BufAdd", "BufLeave" }, {
      callback = function()
        local any_qfll, bufnr = table.unpack(P.any_active_qfll())
        if any_qfll and not P.qf_helper_keys_mapped then
          -- set qf_helper keybindings
          P.qf_helper_keys_mapped = true
          vim.keymap.set(
            "n",
            "<c-n>",
            "<cmd>QNext<cr>",
            { noremap = true, silent = true, desc = "Next item in quickfix/location list" }
          )
          vim.keymap.set(
            "n",
            "<c-p>",
            "<cmd>QPrev<cr>",
            { noremap = true, silent = true, desc = "Previous item in quickfix/location list" }
          )
          vim.keymap.set("n", "dd", "<cmd>Reject<cr>", {
            noremap = true,
            silent = true,
            buffer = bufnr,
            desc = "Delete entry in quickfix/location list (buffer local)",
          })
        elseif not any_qfll and P.qf_helper_keys_mapped then
          -- unset qf_helper keybindings
          P.qf_helper_keys_mapped = false
          vim.keymap.del("n", "<c-n>")
          vim.keymap.del("n", "<c-p>")
        end
      end,
      group = qf_helper,
      pattern = "*",
    })
    require("qf_helper").setup({
      prefer_loclist = false,
      quickfix = {
        default_bindings = false,
      },
      loclist = {
        default_bindings = false,
      },
    })
  end,
}
