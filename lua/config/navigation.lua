return {
  yazi = {
    open_for_directories = true,
    open_multiple_tabs = true,
    keymaps = { show_help = "<f1>" },
    hooks = {
      yazi_closed_successfully = function(chosen_file, config, state)
        -- If no file was chosen (yazi quit without selection)
        if chosen_file == nil then
          -- Check if we are in an empty buffer (likely the one yazi was started from)
          local buf = vim.api.nvim_get_current_buf()
          local name = vim.api.nvim_buf_get_name(buf)
          local type = vim.bo[buf].buftype
          local modified = vim.bo[buf].modified
          
          -- If buffer is empty, unnamed, unmodified, AND it's the only window
          if name == "" and type == "" and not modified and #vim.api.nvim_list_wins() == 1 then
             vim.cmd("quit")
          end
        end
      end,
    },
  },
}
