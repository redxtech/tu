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
		dependencies = { 'rachartier/tiny-devicons-auto-colors.nvim' },
		keys = {
			{ '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
			{ '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
			{ '<leader>cs', '<cmd>Trouble symbols toggle<cr>', desc = 'Symbols (Trouble)' },
			{ '<leader>cS', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP references/definitions/... (Trouble)' },
			{ '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
			{ '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
			{
				'[q',
				function()
					if require('trouble').is_open() then
						require('trouble').prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = 'Previous Trouble/Quickfix Item',
			},
			{
				']q',
				function()
					if require('trouble').is_open() then
						require('trouble').next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = 'Next Trouble/Quickfix Item',
			},
		},
		opts = {
			modes = {
				lsp = {
					win = { position = 'right' },
				},
			},
			action_keys = {
				previous = { 'k', '<Up' },
				next = { 'j', '<Down>' },
			},
		},
	},

	-- Show diagnostics in the top right instead of inline
	{
		'dgagn/diagflow.nvim',
		keys = {
			{
				'<leader>uD',
				function()
					require('diagflow').toggle()
				end,
				desc = 'Toggle diagflow',
			},
		},
		event = 'LspAttach',
	},

	-- OR use verbose diagnostics
	{
		'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
		keys = {
			{
				'<leader>ud',
				function()
					require('lsp_lines').toggle()
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
	},
}
