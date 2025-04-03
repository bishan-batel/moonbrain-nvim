if vim.g.loaded_moonbrain then
	return
end
vim.g.loaded_moonbrain = true

require("nvim-treesitter").setup()

-- define autocommands
vim.cmd([[ autocmd BufNewFile,BufRead *.moonbrain set filetype=moonbrain ]])

require("moonbrain").setup()
