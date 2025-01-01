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
	local client = nil

	-- @return integer?
	local function start_client()
		return vim.lsp.start_client({
			name = "gooslsp",
			cmd = { "/home/bishan_/code/moonbrain/target/debug/meteor-lsp" },
		})
	end

	local augroup = vim.api.nvim_create_augroup("MoonBrain", {})

	vim.api.nvim_create_autocmd({ "FileType" }, {
		pattern = "*.moonbrain",
		command = [[set ft=moonbrain]],
		group = augroup,
	})

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = "*.moonbrain",
		callback = function()
			if not client then
				client = start_client()
			end

			if not client then
				vim.notify("client be ded lol")
			else
				vim.notify("Client")
				vim.lsp.buf_attach_client(0, client)
			end
		end,
		group = augroup,
	})
end

return M
