return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")
		require("fidget").setup({})
		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = {
				"gopls",
				"lua_ls",
				"vtsls",
				-- "quick_lint_js",
				"ruff",
				"docker_compose_language_service",
				"pyright",
				"html",
				"bashls",
				"jsonls",
				"intelephense",
				"htmx", -- cargo needed
				"jinja_lsp", -- cargo needed
			},
			handlers = {
				function(server_name) -- default handler
					lspconfig[server_name].setup({})
				end,
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						settings = {
							Lua = {
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
								},
							},
						},
					})
				end,
				["jinja_lsp"] = function()
					vim.filetype.add({
						extension = {
							jinja = "jinja",
							jinja2 = "jinja",
							j2 = "jinja",
						},
					})

					-- if you want to debug
					vim.lsp.set_log_level(vim.log.levels.WARN)

					local configs = require("lspconfig.configs")

					if not configs.jinja_lsp then
						configs.jinja_lsp = {
							default_config = {
								name = "jinja-lsp",
								cmd = { "jinja-lsp" },
								filetypes = { "jinja", "python", "htmldjango" },
								root_dir = function(fname)
									-- return "."
									return lspconfig.util.find_git_ancestor(fname)
								end,
								init_options = {
									-- templates = "./templates",
									-- backend = { "./src" },
									lang = "python",
								},
							},
						}
					end
					local capabilities =
						require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
					lspconfig.jinja_lsp.setup({
						capabilities = capabilities,
					})
					-- lspconfig.jinja_lsp.setup({})
				end,
			},
		})

		local cmp = require("cmp")
		local luasnip = require("luasnip")
		vim.filetype.add({
			pattern = {
				[".*compose.yaml"] = "yaml.docker-compose",
				[".*compose.yml"] = "yaml.docker-compose",
			},
		})
		-- luasnip.config.set_config{
		--     updateevents = "TextChanged,TextChangedI",
		-- }
		-- local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				-- ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				-- ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({ update_on_insert = true })
	end,
}
