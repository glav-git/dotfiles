vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result cursor centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result cursor centered" })

vim.keymap.set("t", "<C-w>h", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<C-w>j", "<C-\\><C-N><C-w>j")
vim.keymap.set("t", "<C-w>k", "<C-\\><C-N><C-w>k")
vim.keymap.set("t", "<C-w>l", "<C-\\><C-N><C-w>l")

local treeshiter_group = vim.api.nvim_create_augroup("TreeShitterGroup", { clear = true })
local ma_au_group = vim.api.nvim_create_augroup("MaAUGroup", { clear = true })
local yank_group = vim.api.nvim_create_augroup("YankGroup", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = treeshiter_group,
	pattern = "*",
	callback = function(e)
		pcall(vim.treesitter.start, e.buf)
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Remove trailing spaces on pre save, i guess
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = ma_au_group,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

-- read the diary template on vimwiki new diary open
vim.api.nvim_create_autocmd({ "BufNewFile" }, {
	group = ma_au_group,
	pattern = "*vimwiki/diary/[0-9]*.md",
	command = "silent 0r diary/template.md",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = ma_au_group,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "gD", function()
			vim.lsp.buf.declaration()
		end, opts)
	end,
})

vim.keymap.set({ "n" }, "<leader>d", function()
	vim.diagnostic.setqflist()
end)

vim.keymap.set({ "n" }, "<M-n>", "<cmd>cnext<CR>")
vim.keymap.set({ "n" }, "<M-N>", "<cmd>cprev<CR>")
