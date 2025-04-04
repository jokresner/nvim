return {
	{
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		init = function()
			vim.cmd.colorscheme("catppuccin")
			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
