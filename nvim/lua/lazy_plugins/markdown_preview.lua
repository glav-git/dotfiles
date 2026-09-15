return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && npm install",
	init = function()
		vim.g.mkdp_filetypes = { "markdown", "vimwiki.markdown" }
		vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<CR>")
	end,
	ft = { "markdown", "vimwiki.markdown" },
}
