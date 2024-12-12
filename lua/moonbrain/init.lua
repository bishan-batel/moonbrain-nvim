local M = {}

M.setup = function()
	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

	vim.cmd([[ autocmd BufNewFile,BufRead *.moonbrain set filetype=moonbrain ]])
	vim.treesitter.language.register("moonbrain", "moonbrain")

	parser_config["moonbrain"] = {
		install_info = {
			url = "~/code/moonbrain",
			files = { "src/parser.c" },
			branch = "main",
			-- generate_requires_npm = true,
			-- requires_generate_from_grammar = true,
		},
		filetype = "moonbrain",
	}

	vim.api.nvim_create_autocmd({ "BufNewFile, BufRead" }, {
		pattern = "*.moonbrain",
		command = [[set ft=moonbrain]],
	})
end

require("nvim-web-devicons").set_icon({
	moonbrain = {
		icon = "󱓞",
		color = "#f9e2af",
		cterm_color = "65",
		name = "moonbrain",
	},
})

require("nvim-web-devicons").set_icon_by_filetype({ moonbrain = "moonbrain" })

return M
