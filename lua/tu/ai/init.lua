return {
	'supermaven-nvim',
	event = 'InsertEnter',
	after = function(_)
		require('supermaven-nvim').setup({
			keymaps = {
				accept_suggestion = '<M-i>',
			},
			color = {
				-- TODO: use onedark.nvim
				suggestion_color = '#585b70',
			},
			log_level = 'off',
		})
	end,
}
