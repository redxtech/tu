return {
	'rainbow-delimiters-nvim',
	after = function(_)
		local rainbow_delimiters = require('rainbow-delimiters')
		require('rainbow-delimiters.setup').setup({
			strategy = {
				[''] = rainbow_delimiters.strategy['global'],
			},
			query = {
				[''] = 'rainbow-delimiters',
			},
		})
	end,
}
