return {
	'telescope-fzy-native.nvim',
	after = function(_)
		require('telescope').load_extension('fzy_native')
	end,
	-- TODO: do i stil need romgrk/fzy-lua-native?
}
