return {
	"pteroctopus/faster.nvim",
	"Eandrju/cellular-automaton.nvim", -- meme
	{
		"hedyhli/outline.nvim",
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = {
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		config = function()
			require("outline").setup({
				providers = {
					markdown = {
						filetypes = { "markdown", "vimwiki.markdown" },
					},
				},
			})
		end,
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	"tpope/vim-fugitive", -- git
    "tpope/vim-rhubarb", -- fugitive integration for github
    "shumphrey/fugitive-gitlab.vim", -- fugitive integration for gitlab
	{
		"folke/trouble.nvim", -- error list
        cmd = "Trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
}
