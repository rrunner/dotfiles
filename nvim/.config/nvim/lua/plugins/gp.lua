-- chatGPT plugin
-- system dependencies: curl, grep and SoX (for voice via GpWhisper)
return {
  "robitx/gp.nvim",
  event = "VeryLazy",
  config = function()
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
      agents = {
        {
          name = "ChatGPT4",
          chat = true,
          command = true,
          model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
          -- system prompt (use this to specify the persona/role of the AI)
          system_prompt = "You are a general AI assistant.\n\n"
            .. "The user provided the additional info about how they would like you to respond:\n\n"
            .. "- If you're unsure don't guess and say you don't know instead.\n"
            .. "- Ask question if you need clarification to provide better answer.\n"
            .. "- Think deeply and carefully from first principles step by step.\n"
            .. "- Zoom out first to see the big picture and then zoom in to details.\n"
            .. "- Use Socratic method to improve your thinking and coding skills.\n"
            .. "- Don't elide any code from your output if the answer requires coding.\n"
            .. "- Take a deep breath; You've got this!\n",
        },
      },
      hooks = {
        UnitTests = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by writing table driven unit tests for the code above."
            .. "Please prefer pytest for python code and testthat for R code."
          local agent = gp.get_command_agent()
          gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
        end,
        Explain = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please respond by explaining the code above."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
        end,
        CodeReview = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please analyze for code smells and suggest improvements."
          local agent = gp.get_chat_agent()
          gp.Prompt(params, gp.Target.enew("markdown"), nil, agent.model, template, agent.system_prompt)
        end,
        Translator = function(gp, params)
          local agent = gp.get_command_agent()
          local chat_system_prompt = "You are a Translator, please translate between English and Swedish."
          gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
        end,
        BufferChatNew = function(gp, _)
          -- call GpChatNew command in range mode on whole buffer
          vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
        end,
      },
    })
  end,
}
