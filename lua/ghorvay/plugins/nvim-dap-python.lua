return {
	"mfussenegger/nvim-dap-python",
	ft = "python",
	dependencies = {
		"mfussenegger/nvim-dap",
	},
	config = function(_, opts)
		local path = "C:/Users/horva/AppData/Local/nvim-data/mason/packages/debugpy/venv/Scripts/python.exe"
		require("dap-python").setup(path)
	end,
}
