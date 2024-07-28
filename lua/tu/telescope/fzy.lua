return {
	'telescope-fzy-native.nvim',
	event = 'UIEnter',
	after = function(_)
		require('telescope').load_extension('fzy_native')
	end,
	-- TODO: do i stil need romgrk/fzy-lua-native?
}
