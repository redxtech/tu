return {
	{
		'glow-nvim',
		cmd = 'Glow',
		after = function(_)
			require('glow').setup({})
		end,
	},
	{ 'vim-eunuch', event = 'BufEnter' },
	{ 'nvim-numbertoggle', event = 'UIEnter' },
	{
		'url-open',
		cmd = 'URLOpenUnderCursor',
		keys = { { 'gx', '<cmd>URLOpenUnderCursor<cr>' } },
		after = function(_)
			require('url-open').setup({})
		end,
	},
	{
		'moveline-nvim',
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
