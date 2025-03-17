return {
	{
		'stevearc/overseer.nvim',
		keys = {
			{ '<leader>or', '<cmd>OverseerRun<cr> | <cmd>OverseerOpen<cr>', desc = 'Run task' },
			{ '<leader>ot', '<cmd>OverseerToggle<cr>', desc = 'Toggle task runner' },
			{ '<leader>oo', '<cmd>OverseerOpen<cr>', desc = 'Open task runner' },
		},
		opts = {
			strategy = 'toggleterm',
		},
	},
}
