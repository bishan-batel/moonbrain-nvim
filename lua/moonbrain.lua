local M = {}

M.setup = function()
	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	vim.treesitter.language.register("moonbrain", { "moonbrain ", "moonb" })

	parser_config["moonbrain"] = {
		install_info = {
			url = "~/code/moonbrain-nvim/parser/moonbrain/",
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
	local util = require("lspconfig.util")

	require("lspconfig.configs").moonbrain = {
		default_config = {
			cmd = { "/home/bishan_/code/moonbrain/target/debug/meteor-lsp" },
			filetypes = { "moonbrain" },
			root_dir = util.root_pattern(".git"),
		},
	}
	require("lspconfig.configs").moonbrain:setup({})

	local augroup = vim.api.nvim_create_augroup("MoonBrain", {})

	vim.api.nvim_create_autocmd({ "FileType" }, {
		pattern = "*.moonbrain",
		command = [[set ft=moonbrain]],
		group = augroup,
	})
end

return M
