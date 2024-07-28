return {
	'nvim-colorizer-lua',
	event = 'UIEnter',
	after = function(_)
		require('colorizer').setup({
			user_default_options = {
				mode = 'virtualtext',
				names = false,
			},
		})
	end,
}
