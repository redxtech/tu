return {
	'efmls-configs-nvim',
	after = function(_)
		require('efmls-configs').setup({})
	end,
}
