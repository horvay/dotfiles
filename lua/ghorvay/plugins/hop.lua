return {
	"smoka7/hop.nvim",
	cmd = { "HopWord" },
	event = { "BufReadPre", "BufNewFile" },
	opts = { keys = "etovxqpdygfblzhckisuran" },
	config = function()
		require("hop").setup()

		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>jj", "<cmd>HopWord<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader><C-m>", "<cmd>HopWord<cr>", { desc = "Fuzzy find files in cwd" })
		-- local maps = require("base.utils").get_mappings_template()
		-- maps.n["<C-m>"] = { -- The terminal undersand C-m and ENTER as the same key.
		-- 	function()
		-- 		require("hop")
		-- 		vim.cmd("silent! HopWord")
		-- 	end,
		-- 	desc = "Hop to word",
		-- }
	end,
}
