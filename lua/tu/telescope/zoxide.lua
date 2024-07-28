return {
	'zoxide-telescope',
	keys = {
		{ '<leader>fz', "<cmd>lua require('telescope').extensions.zoxide.list()<cr>", desc = 'Z' },
	},
	after = function(_)
		require('telescope').load_extension('zoxide')
	end,
}
