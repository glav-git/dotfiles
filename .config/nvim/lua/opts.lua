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
  name = 'WslClipboard',
  copy = {
    ['+'] = 'win32yank.exe -i',
    ['*'] = 'win32yank.exe -i',
  },
  paste = {
    ['+'] = 'win32yank.exe -o',
    ['*'] = 'win32yank.exe -o',
  },
}

-- g:netrw_liststyle = 'long'
vim.g.netrw_liststyle = 1
vim.g.netrw_sizestyle = "h"
vim.g.netrw_banner = 0
