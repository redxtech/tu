return {
	-- client
	{
		'NeogitOrg/neogit',
		dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim', 'nvim-telescope/telescope.nvim' },
		keys = {
			{ '<leader>gg', '<cmd>Neogit kind=replace<cr>', desc = 'Open Neogit' },
		},
		opts = {
			-- don't scope persisted settings on a per-project basis
			use_per_project_settings = false,
			-- the time after which an output console is shown for slow running commands
			console_timeout = 4000,
		},
	},

	-- better diff viewer
	{
		'sindrets/diffview.nvim',
		name = 'diffview-nvim',
		event = 'UIEnter',
		cmd = {
			'DiffviewFileHistory',
			'DiffviewOpen',
			'DiffviewToggleFiles',
			'DiffviewFocusFiles',
			'DiffviewRefresh',
		},
	},
}
