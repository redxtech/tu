return {
	{ 'tpope/vim-eunuch', event = 'BufEnter' },
	{ 'sitiom/nvim-numbertoggle', event = 'UIEnter' },
	{
		'ellisonleao/glow.nvim',
		name = 'glow-nvim',
		cmd = 'Glow',
		config = function(_, opts)
			require('glow').setup(opts)
		end,
	},
	{
		'sontungexpt/url-open',
		cmd = 'URLOpenUnderCursor',
		keys = { { 'gx', '<cmd>URLOpenUnderCursor<cr>' } },
		config = true,
	},
	{
		'willothy/moveline.nvim',
		name = 'moveline-nvim',
		keys = {
			{
				'<A-k>',
				function()
					require('moveline').up()
				end,
				desc = 'Move line up',
			},
			{
				'<A-j>',
				function()
					require('moveline').down()
				end,
				desc = 'Move line down',
			},
			{
				'<A-k>',
				function()
					require('moveline').block_up()
				end,
				desc = 'Move line up',
				mode = 'v',
			},
			{
				'<A-j>',
				function()
					require('moveline').block_down()
				end,
				desc = 'Move line down',
				mode = 'v',
			},
		},
	},
}
