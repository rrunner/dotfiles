-- chatGPT plugin
-- system dependencies: curl, grep and SoX (for voice via GpWhisper)
return {
  "robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
    local gp_aucmd = vim.api.nvim_create_augroup("Gp", { clear = true })

    -- unset signcolumn and statuscolumn for gp buffers (chatGPT)
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(event)
        local path = vim.api.nvim_buf_get_name(event.buf)
        local filename = path:match("^.+/(.+)$") or path
        if filename:match("^%d%d%d%d%-%d%d%-%d%d%.%d%d%-%d%d%-%d%d%.%d+%.md$") then
          vim.opt_local.signcolumn = "no"
          vim.opt_local.statuscolumn = ""
        end
      end,
      group = gp_aucmd,
      pattern = { "markdown" },
    })

    local utils = require("config.utils")

    local curl = {}
    if utils.IS_WSL then
      curl = { "-k" }
    end

    require("gp").setup({
      curl_params = curl, -- curl_params = { "--proxy", "http://X.X.X.X:XXXX" }
      chat_user_prefix = "human>",
      chat_topic_gen_model = "gpt-4o",
      toggle_target = "vsplit",
      providers = {
        openai = {
          endpoint = "https://api.openai.com/v1/chat/completions",
          secret = os.getenv("OPENAI_API_KEY"),
        },
      },
      agents = {
        {
          name = "ChatGPT4",
          chat = true,
          command = true,
          model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = require("gp.defaults").chat_system_prompt,
        },
      },
      hooks = {
        UnitTests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by writing table driven unit tests for the code above."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.vnew, agent, template)
        end,
        Explain = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by explaining the code above."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.popup, agent, template)
        end,
        CodeReview = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvements."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.enew("markdown"), agent, template)
        end,
        Translator = function(gp, params)
          local chat_system_prompt = "You are a Translator, please translate between English and Chinese."
          gp.cmd.ChatNew(params, chat_system_prompt)
        end,
        BufferChatNew = function(gp, _)
          -- call GpChatNew command in range mode on whole buffer
          vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
        end,
      },
    })
  end,
}
