return {
	{
		'SuperBo/fugit2.nvim',
		dependencies = {
			'MunifTanjim/nui.nvim',
			'nvim-tree/nvim-web-devicons',
			'nvim-lua/plenary.nvim',
			{
				'chrisgrieser/nvim-tinygit', -- optional: for Github PR view
				dependencies = { 'stevearc/dressing.nvim' },
			},
		},
		opts = {
			width = 100,
			external_diffview = true,
		},
		cmd = { 'Fugit2', 'Fugit2Blame', 'Fugit2Diff', 'Fugit2Graph' },
		keys = {
			{ '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' },
		},
	},

	-- external diffview
	{
		'sindrets/diffview.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		-- lazy, only load diffview by these commands
		cmd = {
			'DiffviewFileHistory',
			'DiffviewOpen',
			'DiffviewToggleFiles',
			'DiffviewFocusFiles',
			'DiffviewRefresh',
		},
	},
}
