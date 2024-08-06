return {
	-- amongst your other plugins
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = true,
		opts = function()
			local keymap = vim.keymap -- for conciseness

			keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<cr>", { desc = "Toggle Terminal 1" })
			keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<cr>", { desc = "Toggle Terminal 2" })
			keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm<cr>", { desc = "Toggle Terminal 3" })
			keymap.set("n", "<leader>t4", "<cmd>4ToggleTerm<cr>", { desc = "Toggle Terminal 4" })
			keymap.set("n", "<leader>ta", "<cmd>ToggleTermToggleAll<cr>", { desc = "Toggle all terminals" })
		end,
	},
	-- or
}
