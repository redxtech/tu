return {
	-- show icon when code actions are available
	{
		'kosayoda/nvim-lightbulb',
		event = 'BufReadPost',
		opts = {
			autocmd = {
				enabled = true,
			},
		},
	},
}
