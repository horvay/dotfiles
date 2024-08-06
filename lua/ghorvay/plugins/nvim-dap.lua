return {
	"rcarriga/nvim-dap-ui",
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	config = function()
		local dap = require("dap")

		dap.adapters.coreclr = {
			type = "executable",
			command = "/usr/local/bin/netcoredbg/netcoredbg",
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",

				program = function()
					return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/net7.0/Nls", "file")
				end,
			},
		}

		dap.configurations.razor = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",

				program = function()
					return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/net7.0/Nls", "file")
				end,
			},
		}
		local keymap = vim.keymap -- for conciseness

		keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
		keymap.set("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { desc = "continue" })
		keymap.set("n", "<C-F5>", "<Cmd>lua require'dap'.terminate()<CR>", { desc = "terminal" })
		keymap.set("n", "<F9>", "<Cmd>lua require'dap'.restart_frame()<CR>", { desc = "restart_frame" })
		keymap.set("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { desc = "continue" })
		keymap.set("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { desc = "step_into" })
		keymap.set("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { desc = "step_out" })
		keymap.set("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "toggle_breakpoint" })
		keymap.set("n", "<Leader>db", "<Cmd>lua require'dap'.clear_breakpoints()<CR>", { desc = "clear_breakpoints" })
		keymap.set(
			"n",
			"<Leader>B",
			"<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
			{ desc = "breakpoint condition" }
		)
		keymap.set(
			"n",
			"<Leader>lp",
			"<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
			{ desc = "log message" }
		)
		keymap.set("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { desc = "open" })
		keymap.set("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { desc = "run_last" })

		local dapui = require("dapui")

		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			mappings = {
				-- Use a table to apply multiple mappings
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			-- Use this to override mappings for specific elements
			element_mappings = {
				-- Example:
				-- stacks = {
				--   open = "<CR>",
				--   expand = "o",
				-- }
			},
			-- Expand lines larger than the window
			-- Requires >= 0.7
			expand_lines = vim.fn.has("nvim-0.7") == 1,
			-- Layouts define sections of the screen to place windows.
			-- The position can be "left", "right", "top" or "bottom".
			-- The size specifies the height/width depending on position. It can be an Int
			-- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
			-- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
			-- Elements are the elements shown in the layout (in order).
			-- Layouts are opened in order so that earlier layouts take priority in window sizing.
			layouts = {
				{
					elements = {
						-- Elements can be strings or table with id and size keys.
						{ id = "scopes", size = 0.25 },
						"breakpoints",
						"stacks",
						"watches",
					},
					size = 40, -- 40 columns
					position = "left",
				},
				{
					elements = {
						"repl",
						"console",
					},
					size = 0.25, -- 25% of total lines
					position = "bottom",
				},
			},
			controls = {
				-- Requires Neovim nightly (or 0.8 when released)
				enabled = true,
				-- Display controls in this element
				element = "repl",
				icons = {
					pause = "",
					play = "",
					step_into = "",
					step_over = "",
					step_out = "",
					step_back = "",
					run_last = "↻",
					terminate = "□",
				},
			},
			floating = {
				max_height = nil, -- These can be integers or a float between 0 and 1.
				max_width = nil, -- Floats will be treated as percentage of your screen.
				border = "single", -- Border style. Can be "single", "double" or "rounded"
				mappings = {
					close = { "q", "<Esc>" },
				},
			},
			windows = { indent = 1 },
			render = {
				max_type_length = nil, -- Can be integer or nil.
				max_value_lines = 100, -- Can be integer or nil.
			},
		})

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		keymap.set("n", "<Leader>de", "<Cmd>lua require'dapui'.eval()<CR>", { desc = "eval" })
		keymap.set("n", "<Leader>du", "<Cmd>lua require'dapui'.toggle()<CR>", { desc = "toggle debug ui" })
		keymap.set("n", "<Leader>dh", "<Cmd>lua require'dapui'.hover()<CR>", { desc = "hover" })
	end,
}
