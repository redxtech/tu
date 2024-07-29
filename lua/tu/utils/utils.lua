local function sortMap(mod, mode)
	local rPre = (mod == '') and '' or 'vi' .. mod .. '<Esc>'

	return {
		'go' .. mod,
		rPre .. '<cmd>Sort<cr>',
		desc = 'Sort',
		silent = true,
		mode = mode or 'n',
	}
end

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
		'sQVe/sort.nvim',
		name = 'sort-nvim',
		keys = {
			sortMap('', 'v'),
			sortMap('"'),
			sortMap("'"),
			sortMap('('),
			sortMap('['),
			sortMap('{'),
			sortMap('p'),
		},
		config = function(_, opts)
			require('sort').setup(opts)
		end,
	},
	{
		'max397574/better-escape.nvim',
		name = 'better-escape-nvim',
		config = function()
			require('better_escape').setup()
		end,
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
