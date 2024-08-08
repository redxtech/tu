return {
	-- session sharing
	{
		'jbyuki/instant.nvim',
		dependencies = { 'MunifTanjim/nui.nvim', name = 'nui-nvim' },
		cmd = {
			'InstantStartSingle',
			'InstantJoinSingle',
			'InstantStartSession',
			'InstantJoinSession',
			'InstantStatus',
			'InstantOpenAll',
			'InstantStartServer',
			'InstantMark',
		},
		name = 'instant-nvim',
	},

	-- toggle features that make it easier for observers
	-- to see what you are doing
	{
		'redxtech/sharing.nvim',
		name = 'sharing-nvim',
		keys = {
			{ '<leader>ts', '<cmd>Sharing toggle<cr>', desc = 'Toggle sharing features' },
		},
		init = function()
			vim.g.instant_username = 'redxtech'
		end,
		config = function(_, opts)
			require('sharing').setup(opts)
		end,
	},
}
