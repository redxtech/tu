return {
	'Comment-nvim',
	enabled = false,
	after = function(_)
		require('Comment').setup()
	end,
}
