-- define icons for the diagnostics in the sign column
-- even though we have them disabled
vim.fn.sign_define('DiagnosticSignError', { texthl = 'DiagnosticSignError', text = '' })
vim.fn.sign_define('DiagnosticSignWarn', { texthl = 'DiagnosticSignWarn', text = '' })
vim.fn.sign_define('DiagnosticSignHint', { texthl = 'DiagnosticSignHint', text = '' })
vim.fn.sign_define('DiagnosticSignInfo', { texthl = 'DiagnosticSignInfo', text = '' })

return {
	-- UI for viewing all diagnostics
	-- TODO: improve speed?
	{
		'folke/trouble.nvim',
		name = 'trouble-nvim',
		dependencies = { 'rachartier/tiny-devicons-auto-colors.nvim' },
		keys = {
			{ '<leader>xx', '<cmd>Trouble<cr>', desc = 'Diagnostics' },
			{ '<leader>xw', '<cmd>Trouble workspace_diagnostics<cr>', desc = 'Workspace Diagnostics' },
			{ '<leader>xd', '<cmd>Trouble document_diagnostics<cr>', desc = 'Document Diagnostics' },
			{ '<leader>xq', '<cmd>Trouble quickfix<cr>', desc = 'Quickfix' },
			{ '<leader>xl', '<cmd>Trouble loclist<cr>', desc = 'Location List' },
			{ 'gR', '<cmd>Trouble lsp_references<cr>', desc = 'LSP References' },
		},
		config = function(_, opts)
			require('trouble').setup(opts)
		end,
		opts = {
			action_keys = {
				previous = { 'k', '<Up' },
				next = { 'j', '<Down>' },
			},
		},
	},

	-- Show diagnostics in the top right instead of inline
	-- TODO: gets in the way sometimes, consolidate with fidget and noice?
	{
		'dgagn/diagflow.nvim',
		name = 'diagflow-nvim',
		-- enabled = false,
		event = 'LspAttach',
		config = function(_, opts)
			require('diagflow').setup(opts)
		end,
	},

	-- OR use verbose diagnostics
	{
		'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
		name = 'lsp-lines-nvim',
		-- enabled = false,
		keys = {
			{
				'<leader>ud',
				function()
					vim.g.lsp_lines_active = not vim.g.lsp_lines_active
					vim.diagnostic.config({
						virtual_lines = vim.g.lsp_lines_active,
					})
					require('lsp_lines').toggle()
					require('diagflow').toggle()
				end,
				desc = 'Toggle Verbose Diagnostics',
			},
		},
		init = function()
			vim.g.lsp_lines_active = false
			vim.diagnostic.config({
				-- disable the "E", "H" in the sign column (left of line numbers)
				signs = false,
				virtual_lines = vim.g.lsp_lines_active,
			})
			-- avoid showing lsp lines on lazy.nvim popup
			-- https://github.com/folke/lazy.nvim/issues/620
			vim.diagnostic.config({ virtual_lines = false }, require('lazy.core.config').ns)
		end,
		config = function(_, opts)
			require('lsp_lines').setup(opts)
		end,
	},
}
