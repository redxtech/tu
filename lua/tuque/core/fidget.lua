return {
	-- notifications
	'fidget-nvim',
	after = function(_)
		require('fidget').setup({
			notification = { window = { normal_hl = 'Normal' } },
		})
	end,
}
