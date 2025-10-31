return {
	{
		'linrongbin16/gitlinker.nvim',
		cmd = 'GitLink',
		keys = {
			{ '<leader>gyf', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = 'Copy file url' },
			{ '<leader>gof', '<cmd>GitLink!<cr>', mode = { 'n', 'v' }, desc = 'Open file in browser' },

			{ '<leader>gyb', '<cmd>GitLink current_branch<cr>', mode = { 'n', 'v' }, desc = 'Copy branch url' },
			{ '<leader>gob', '<cmd>GitLink! current_branch<cr>', mode = { 'n', 'v' }, desc = 'Open branch in browser' },

			{ '<leader>gyr', '<cmd>GitLink default_branch<cr>', mode = { 'n', 'v' }, desc = 'Copy repo url' },
			{ '<leader>gor', '<cmd>GitLink! default_branch<cr>', mode = { 'n', 'v' }, desc = 'Open repo in browser' },

			{ '<leader>goB', '<cmd>GitLink! blame<cr>', mode = { 'n', 'v' }, desc = 'Open blame in browser' },
		},
		config = true
	},
}
