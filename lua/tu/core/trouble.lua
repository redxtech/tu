return {
	'trouble-nvim',
	keys = {
		{ '<leader>xx', '<cmd>Trouble<cr>', desc = 'Diagnostics' },
		{ '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', desc = 'Workspace Diagnostics' },
		{ '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', desc = 'Document Diagnostics' },
		{ '<leader>xq', '<cmd>Trouble quickfix<cr>', desc = 'Quickfix' },
		{ '<leader>xl', '<cmd>Trouble loclist<cr>', desc = 'Location List' },
		{ 'gR', '<cmd>Trouble lsp_references<cr>', desc = 'LSP References' },
	},
	before = function(_)
		-- define icons for the diagnostics in the sign column
		-- even though we have them disabled
		vim.fn.sign_define('DiagnosticSignError', { texthl = 'DiagnosticSignError', text = '' })
		vim.fn.sign_define('DiagnosticSignWarn', { texthl = 'DiagnosticSignWarn', text = '' })
		vim.fn.sign_define('DiagnosticSignHint', { texthl = 'DiagnosticSignHint', text = '' })
		vim.fn.sign_define('DiagnosticSignInfo', { texthl = 'DiagnosticSignInfo', text = '' })
	end,
	after = function(_)
		require('trouble').setup({
			action_keys = {
				previous = { 'k', '<Up' },
				next = { 'j', '<Down>' },
			},
		})
	end,
}
