return {
	'nvim-navbuddy',
	event = 'LspAttach',
	keys = {
		{ '<leader>nv', '<cmd>Navbuddy<cr>', desc = 'Navigate' },
	},
	after = function(_)
		require('nvim-navbuddy').setup({
			lsp = {
				auto_attach = true,
			},
		})
	end,
}
