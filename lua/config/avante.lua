local M = {}

M.opts = {
  provider = "copilot",
  input = { provider = "snacks", provider_opts = { title = "Avante Input", icon = " " } },
  system_prompt = function()
    local hub = require("mcphub").get_hub_instance()
    return hub and hub:get_active_servers_prompt() or ""
  end,
  custom_tools = function()
    return { require("mcphub.extensions.avante").mcp_tool() }
  end,
}

M.img_clip = {
  default = {
    embed_image_as_base64 = false,
    prompt_for_file_name = false,
    drag_and_drop = { insert_mode = true },
    use_absolute_path = true,
  },
}

M.mcphub = { extensions = { avante = { make_slash_commands = true } } }

return M


