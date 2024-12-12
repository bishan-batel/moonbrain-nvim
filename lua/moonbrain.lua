local M = {}

M.setup = function()
	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	vim.treesitter.language.register("moonbrain", { "moonbrain ", "moonb" })

	parser_config["moonbrain"] = {
		install_info = {
			url = "~/code/moonbrain/parser/moonbrain/",
			files = { "src/parser.c" },
			branch = "main",
			-- generate_requires_npm = true,
			-- requires_generate_from_grammar = true,
		},
		filetype = "moonbrain",
	}

	require("nvim-web-devicons").set_icon({
		moonbrain = {
			icon = "󱓞",
			color = "#f9e2af",
			cterm_color = "65",
			name = "Moonbrain",
		},
	})

	require("nvim-web-devicons").set_icon_by_filetype({ moonbrain = "moonbrain" })
end

return M
