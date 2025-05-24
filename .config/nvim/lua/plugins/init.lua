return {
    "Eandrju/cellular-automaton.nvim", -- meme
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    "tpope/vim-fugitive", -- git
    {
        "folke/trouble.nvim", -- error list
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        -- Normal mode keybindings:
        -- gcc: comment line
        -- gcb: comment block
        -- gcA: add comment to the end of the line
        -- gco: add comment on the next line
        -- gcO: add comment on the previous line
        --
        -- Visual mode keybindings:
        -- gc: comment line
        -- gb: comment block
        'numToStr/Comment.nvim', opts = {}, lazy = false
    }
}
