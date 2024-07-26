return {
	'lsp-lines-nvim',
	event = 'LspAttach',
	keys = {
		{
			'<leader>ud',
			function()
				vim.g.lsp_lines_active = not vim.g.lsp_lines_active
				vim.diagnostic.config({
					virtual_lines = vim.g.lsp_lines_active,
				})
				require('diagflow').toggle()
			end,
			desc = 'Toggle Verbose Diagnostics',
		},
	},
	before = function(_)
		vim.g.lsp_lines_active = false
		vim.diagnostic.config({
			-- disable the "E", "H" in the sign column (left of line numbers)
			signs = false,
			virtual_lines = vim.g.lsp_lines_active,
		})
	end,
	after = function(_)
		require('diagflow').setup({})
	end,
}
