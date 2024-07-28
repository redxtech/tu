return {
	'neovim-session-manager',
	after = function(_)
		require('session_manager').setup({})
	end,
}
