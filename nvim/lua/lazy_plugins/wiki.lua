vim.g.vimwiki_list = {
	{
		path = "~/Documents/vimwiki",
		syntax = "markdown",
		ext = ".md",
	},
}
vim.g.vimwiki_filetypes = { "markdown" }
vim.g.vimwiki_global_ext = 0
vim.g.vimwiki_conceallevel = 0
vim.g.vimwiki_conceal_code_blocks = 0
return { "vimwiki/vimwiki" }
