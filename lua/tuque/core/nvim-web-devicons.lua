return {
	'nvim-web-devicons',
	event = 'UIEnter',
	after = function(_)
		require('nvim-web-devicons').setup()
	end,
}
