return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	-- event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"seblj/roslyn.nvim",
		"tris203/rzls.nvim",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()
		--`jlocal client_capabilities = require("lsp").client_capabilities
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for concisenes

		--require("rzls").setup({
		--	on_attach = function() end, -- Blank function. Should be called in another autocmd anyway
		--	path = "~/razor/artifacts/LanguageServer/Debug/net8.0/osx-x64",
		--	filetypes = { "cs", "razor" },
		--})
		-- lspconfig.omnisharp.setup({
		-- 	cmd = { "dotnet", "/usr/local/Cellar/omnisharp/1.35.3/libexec/omnisharp/OmniSharp.Roslyn.dll" },
		-- 	-- Enables support for reading code style, naming convention and analyzer
		-- 	-- settings from .editorconfig.
		-- 	enable_editorconfig_support = true,
		-- 	-- If true, MSBuild project system will only load projects for files that
		-- 	-- were opened in the editor. This setting is useful for big C# codebases
		-- 	-- and allows for faster initialization of code navigation features only
		-- 	-- for projects that are relevant to code that is being edited. With this
		-- 	-- setting enabled OmniSharp may load fewer projects and may thus display
		-- 	-- incomplete reference lists for symbols.
		-- 	enable_ms_build_load_projects_on_demand = false,
		-- 	-- Enables support for roslyn analyzers, code fixes and rulesets.
		-- 	enable_roslyn_analyzers = false,
		-- 	-- Specifies whether 'using' directives should be grouped and sorted during
		-- 	-- document formatting.
		-- 	organize_imports_on_format = true,
		-- 	-- Enables support for showing unimported types and unimported extension
		-- 	-- methods in completion lists. When committed, the appropriate using
		-- 	-- directive will be added at the top of the current file. This option can
		-- 	-- have a negative impact on initial completion responsiveness,
		-- 	-- particularly for the first few completion sessions after opening a
		-- 	-- solution.
		-- 	enable_import_completion = true,
		-- 	-- Specifies whether to include preview versions of the .NET SDK when
		-- 	-- determining which version to use for project loading.
		-- 	sdk_include_prereleases = true,
		-- 	-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
		-- 	-- true
		-- 	analyze_open_documents_only = false,
		-- })

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["svelte"] = function()
				-- configure svelte server
				lspconfig["svelte"].setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								-- Here use ctx.match instead of ctx.file
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,
			["graphql"] = function()
				-- configure graphql language server
				lspconfig["graphql"].setup({
					capabilities = capabilities,
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				})
			end,
			["emmet_ls"] = function()
				-- configure emmet language server
				lspconfig["emmet_ls"].setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,
		})
		require("roslyn").setup({
			dotnet_cmd = "dotnet",
			--	version = "4.10.0-2.24102.11",
			capabilities = capabilities,
			exe = vim.fs.joinpath(
				vim.fn.stdpath("data") --[[@as string]],
				"roslyn",
				"Microsoft.CodeAnalysis.LanguageServer.dll"
			),
			filewatching = true,
			config = {
				cmd = { "dotnet" },
			},
			settings = {
				["csharp|completion"] = {
					["dotnet_provide_regex_completions"] = true,
					["dotnet_show_completion_items_from_unimported_namespaces"] = true,
					["dotnet_show_name_completion_suggestions"] = true,
				},
				["csharp|highlighting"] = {
					["dotnet_highlight_related_json_components"] = true,
					["dotnet_highlight_related_regex_components"] = true,
				},
				["csharp|inlay_hints"] = {
					["csharp_enable_inlay_hints_for_implicit_object_creation"] = true,
					["csharp_enable_inlay_hints_for_implicit_variable_types"] = true,
					["csharp_enable_inlay_hints_for_lambda_parameter_types"] = true,
					["csharp_enable_inlay_hints_for_types"] = true,
					["dotnet_enable_inlay_hints_for_indexer_parameters"] = false,
					["dotnet_enable_inlay_hints_for_literal_parameters"] = true,
					["dotnet_enable_inlay_hints_for_object_creation_parameters"] = true,
					["dotnet_enable_inlay_hints_for_other_parameters"] = true,
					["dotnet_enable_inlay_hints_for_parameters"] = true,
					["dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix"] = false,
					["dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name"] = false,
					["dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent"] = false,
				},
				["navigation"] = {
					["dotnet_navigate_to_decompiled_sources"] = true,
				},
			},
			on_attach = function() end, -- Blank function. Should be called in another autocmd anyway
		})
		require("go").setup({
			-- other setups ....
			lsp_cfg = {
				capabilities = capabilities,
				-- other setups
			},
		})
		-- require("../../../rzls").setup({
		-- 	-- on_attach = on_attach,
		-- 	capabilities = capabilities,
		-- 	path = "/Users/ghorvay/.vscode/extensions/ms-dotnettools.csharp-2.34.12-darwin-x64/.razor",
		-- })
	end,
}
