return {
	'smart-open',
	keys = {
		{
			'<leader>ff',
			function()
				require('telescope').extensions.smart_open.smart_open({ cwd_only = true })
			end,
			desc = 'Files',
		},
	},
	after = function(_)
		require('telescope').load_extension('smart_open')
	end,
}
