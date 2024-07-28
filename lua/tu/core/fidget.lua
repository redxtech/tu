return {
	-- notifications
	'fidget-nvim',
	event = 'UIEnter',
	after = function(_)
		require('fidget').setup({
			notification = { window = { normal_hl = 'Normal' } },
		})
	end,
}
