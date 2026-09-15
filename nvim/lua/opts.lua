vim.opt.nu = true
vim.opt.relativenumber = true

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.opt.smartindent = true
vim.opt.colorcolumn = "80"

-- wsl clipboard provider
-- win32yank.exe not native but works great with cirylic symbols.
-- You can install it on windows just downloading a release and copying .exe
-- into Windows/System32 folder, from where it should be automatically available
-- in wsl PATH. Link to repo: https://github.com/equalsraf/win32yank
vim.g.clipboard = {
	name = "WslClipboard",
	copy = {
		["+"] = "win32yank.exe -i",
		["*"] = "win32yank.exe -i",
	},
	paste = {
		["+"] = "win32yank.exe -o",
		["*"] = "win32yank.exe -o",
	},
}

vim.g.netrw_liststyle = 1 -- long style
vim.g.netrw_sizestyle = "h"
vim.g.netrw_banner = 0

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
