return {
	{
		'supermaven-inc/supermaven-nvim',
		opts = {
			keymaps = {
				accept_suggestion = '<M-i>',
			},
			ignore_filetypes = { NeogitCommitMessage = true },
			color = {
				-- TODO: use dracula colors
				suggestion_color = '#585b70',
			},
			log_level = 'off',
		},
	},
}
