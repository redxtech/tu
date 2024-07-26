return {
	'dashboard-nvim',
	after = function(_)
		require('dashboard').setup({
			theme = 'hyper',
			config = {
				week_header = {
					enable = true,
				},
				project = {
					action = 'NeovimProjectLoadDashboard ',
				},
				mru = {
					limit = 6,
					-- cwd_only = false,
				},
				shortcut = {
					{
						desc = ' lazy',
						group = 'Green',
						action = 'Lazy',
						key = 'l',
					},
					{
						desc = '  update',
						group = 'Orange',
						action = 'Lazy update',
						key = 'u',
					},
					-- {
					-- 	desc = '  last session',
					-- 	group = 'Yellow',
					-- 	action = 'NeovimProjectLoadRecent',
					-- 	key = 's',
					-- },
					{
						desc = '  projects',
						group = 'Cyan',
						action = 'Telescope neovim-project discover',
						key = 'p',
					},
					{
						desc = '  sessions',
						group = 'Purple',
						action = 'Telescope neovim-project history',
						key = 'h',
					},
					{
						desc = '󱁿  config',
						group = 'Pink',
						action = 'NeovimProjectLoad ~/.config/nvim',
						key = 'c',
					},
					{
						desc = '󰤆 quit',
						group = 'Red',
						action = 'q',
						key = 'q',
					},
				},
			},
		})
	end,
}
