require("vim._core.ui2").enable({})

vim.o.exrc = true
vim.o.secure = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.o.undofile = true
vim.o.nu = true
vim.opt.relativenumber = true
vim.o.cursorcolumn = true

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.o.winborder = "rounded"

local keymap_i = 1
local keymaps = { "", "ru-custom-typography", "uk-custom-typography" }
vim.keymap.set({ "n", "i", "v" }, "<M-l>", function()
	keymap_i = keymap_i % 3 + 1
	vim.o.keymap = keymaps[keymap_i]
end)
vim.o.iminsert = 0
vim.o.imsearch = 0

vim.opt.smartindent = true
vim.opt.colorcolumn = "80"

-- TODO: move this out to a template
-- wsl clipboard provider
-- win32yank.exe not native but works great with cirylic symbols.
-- You can install it on windows just downloading a release and copying .exe
-- into Windows/System32 folder, from where it should be automatically available
-- in wsl PATH. Link to repo: https://github.com/equalsraf/win32yank
-- vim.g.clipboard = {
-- 	name = "WslClipboard",
-- 	copy = {
-- 		["+"] = "win32yank.exe -i",
-- 		["*"] = "win32yank.exe -i",
-- 	},
-- 	paste = {
-- 		["+"] = "win32yank.exe -o",
-- 		["*"] = "win32yank.exe -o",
-- 	},
-- }

vim.g.netrw_liststyle = 1 -- long style
vim.g.netrw_sizestyle = "h"
vim.g.netrw_banner = 0
vim.g.vim_markdown_conceal_code_blocks = 0

vim.treesitter.language.register("yaml", "yaml.docker-compose")
vim.treesitter.language.register("markdown", "vimwiki")

-- on netrw buffer first open - check liststyle and if it matches 1 - set custom sort sequence
local netrw_au_group = vim.api.nvim_create_augroup("MaNetrwAUGroup", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = netrw_au_group,
	pattern = "netrw",
	once = true,
	callback = function()
		if vim.g.netrw_liststyle == 1 then
			vim.g.netrw_sort_sequence = vim.g.netrw_sort_sequence:gsub("%$", "\\s\\s\\+\\d")
		end
	end,
})

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	float = {
		source = true,
	},
	jump = {
		float = true,
	},
	signs = true,
})
