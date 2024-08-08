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
}
