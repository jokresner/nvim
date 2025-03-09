return {
	"bassamsdata/namu.nvim",
	config = function()
		require("namu").setup({
			-- Enable the modules you want
			namu_symbols = {
				enable = true,
				options = {}, -- here you can configure namu
			},
			-- Optional: Enable other modules if needed
			colorscheme = {
				enable = false,
				options = {
					-- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
					persist = true, -- very efficient mechanism to Remember selected colorscheme
					write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
				},
			},
			ui_select = { enable = false }, -- vim.ui.select() wrapper
		})
		-- === Suggested Keymaps: ===
		local namu = require("namu.namu_symbols")
		local colorscheme = require("namu.colorscheme")
		vim.keymap.set("n", "<leader>sy", ":Namu symbols<cr>", {
			desc = "Jump to LSP symbol",
			silent = false,
		})
		vim.keymap.set("n", "<leader>tn", ":Namu colorscheme<cr>", {
			desc = "Colorscheme Picker",
			silent = false,
		})
	end,
}

-- vim: ts=2 sts=2 sw=2 et
