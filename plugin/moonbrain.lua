if vim.g.loaded_moonbrain then
	return
end
vim.g.loaded_moonbrain = true

require("nvim-treesitter").setup()

local api = vim.api

-- define autocommands
local augroup = api.nvim_create_augroup("MoonBrain", {})

vim.cmd([[ autocmd BufNewFile,BufRead *.moonbrain set filetype=moonbrain ]])

-- vim.api.nvim_create_autocmd({ "BufNewFile, BufRead" }, {
-- 	pattern = "*.moonbrain",
-- 	command = [[set ft=moonbrain]],
-- 	group = augroup,
-- })
--
require("moonbrain").setup()
