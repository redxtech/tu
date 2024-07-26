return {
	-- nested neovim instances open in the parent
	'flatten-nvim',
	priority = 1001,
	after = function(_)
		require('flatten').setup({
			window = { open = 'smart' },
		})
	end,
}
