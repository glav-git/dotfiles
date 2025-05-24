return {
	"mhartington/formatter.nvim",
	config = function()
		local util = require("formatter.util")
		-- Utilities for creating configurations
		-- local util = require("formatter.util")
		-- can be used for  example like this util.get_current_buffer_file_name()

		-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = {
				python = { require("formatter.filetypes.python").black },
				go = { require("formatter.filetypes.go").gofmt },
				lua = { require("formatter.filetypes.lua").stylua },
				javascript = { require("formatter.filetypes.javascript").prettier },
				typescript = { require("formatter.filetypes.typescript").prettier },
				typescriptreact = { require("formatter.filetypes.typescriptreact").prettier },
				javascriptreact = { require("formatter.filetypes.javascriptreact").prettier },
				htmldjango = {
					function()
						return {
							exe = "djlint",
							args = {
								util.escape_path(util.get_current_buffer_file_path()),
								"--extension=html",
								"--reformat",
								"--quiet",
							},
							stdin = true,
						}
					end,
				},
			},
		})

		vim.keymap.set("n", "<leader>f", ":Format<CR>")
	end,
}
