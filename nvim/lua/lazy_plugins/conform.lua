return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		local prettier = { "prettierd", "prettier", stop_after_first = true }
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				proto = { "buf" },
				go = { "gofmt" },
				javascript = prettier,
				typescript = prettier,
				typescriptreact = prettier,
				javascriptreact = prettier,
				html = prettier,
				sql = { "sqlfluff" },
				htmldjango = { "djlint" },
			},
		})

		conform.formatters.isort = {
			append_args = { "--profile", "black" },
		}

		conform.formatters.sqlfluff = {
			args = {
				-- "format",
				"fix",
				"--disable-progress-bar",
				"--nocolor",
				"--dialect=postgres",
				"-",
			},
		}

		vim.keymap.set("n", "<leader>f", function()
			conform.format({ async = true })
		end)
	end,
}
