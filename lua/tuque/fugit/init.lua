return {
	{
		'fugit2',
		after = function(_)
			require('fugit2').setup({
				width = 100,
				external_diffview = true,
			})
		end,
		cmd = { 'Fugit2', 'Fugit2Blame', 'Fugit2Diff', 'Fugit2Graph' },
		keys = {
			{ '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' },
		},
	},
	{ 'nvim-tinygit', event = 'UIEnter' },
	{ 'diffview-nvim', event = 'UIEnter' },
	{ 'nui-nvim', event = 'UIEnter' },
}
