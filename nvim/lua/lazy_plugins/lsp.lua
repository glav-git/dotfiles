local function get_jinja_lsp_config()
	vim.filetype.add({
		extension = {
			jinja = "jinja",
			jinja2 = "jinja",
			j2 = "jinja",
		},
	})

	return {
		default_config = {
			name = "jinja-lsp",
			cmd = { "jinja-lsp" },
			filetypes = { "jinja", "python", "htmldjango" },
			root_dir = function(fname)
				return vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
			end,
			init_options = {
				-- templates = "./templates",
				-- backend = { "./src" },
				lang = "python",
			},
		},
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}
end

return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			-- "gopls",
			"lua_ls",
			"ts_ls",
			-- "vtsls",
			-- "quick_lint_js",
			-- "protols",
			"buf_ls",
			"docker_compose_language_service",
			"pyright",
			"html",
			"bashls",
			"intelephense",
			"htmx", -- cargo needed
			"jinja_lsp", -- cargo needed
			"postgres-language-server",
		},
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		require("fidget").setup({})
		require("mason").setup({})
		require("mason-lspconfig").setup({})

		vim.lsp.config("jinja_lsp", get_jinja_lsp_config())
		-- vim.lsp.config("protols", {
		-- 	cmd = {
		-- 		"protols",
		-- 		-- "--include-paths=/home/pikarchu/.local/include/googleapis",
		-- 	},
		-- })
		vim.lsp.config("postgres_lsp", {
			cmd = { "postgres-language-server", "lsp-proxy" },
			root_makers = { "postgres-language-server.jsonc" },
		})

		vim.lsp.config("tsgo", {
			cmd = function(dispatchers, config)
				local cmd = "tsgo"
				if (config or {}).root_dir then
					local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
					if vim.fn.executable(local_cmd) == 1 then
						cmd = local_cmd
					end
				end
				return vim.lsp.rpc.start(
					{
						"systemd-run",
						"--user",
						"--scope",
						"-p",
						"CPUQuota=600%",
						"-p",
						"MemoryMax=16G",
						"-p",
						"MemorySwapMax=infinity",
						"--",
						cmd,
						"--lsp",
						"--stdio",
					},
					dispatchers
				)
				-- return vim.lsp.rpc.start({ "cpulimit", "-l", "600", "--", cmd, "--lsp", "--stdio" }, dispatchers)
				-- return vim.lsp.rpc.start({"/home/pikarchu/.local/bin/tsgopidoraslsp"}, dispatchers)
			end,
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})

		vim.lsp.enable("htmx", false)

		vim.lsp.enable("ts_ls", true)
		vim.lsp.enable("tsgo", false)
		-- vim.lsp.enable("ts_ls", false)
		-- vim.lsp.enable("tsgo", true)

		vim.lsp.enable("gopls", true)
		vim.lsp.config("gopls", {})

		local cmp = require("cmp")
		vim.filetype.add({
			pattern = {
				[".*compose.yaml"] = "yaml.docker-compose",
				[".*compose.yml"] = "yaml.docker-compose",
			},
		})

		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm(),
			}),
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},
			sources = cmp.config.sources({ { name = "nvim_lsp" } }, { { name = "buffer" } }),
		})

		vim.diagnostic.config({ update_on_insert = true })
	end,
}
