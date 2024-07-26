return {
	'tiny-devicons-auto-colors-nvim',
	event = 'UIEnter',
	after = function(_)
		require('tiny-devicons-auto-colors').setup({})
	end,
}
