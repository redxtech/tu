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
		'stevearc/oil.nvim',
		name = 'oil-nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		keys = {
			{ '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
		},
		opts = {
			columns = { 'icon', 'size' },
			delete_to_trash = true,
		},
		config = function(_, opts)
			require('oil').setup(opts)
		end,
	},
	{
		'redxtech/nix-reaver.nvim',
		name = 'nix-reaver-nvim',
		keys = {
			{ '<leader>ur', ':NixReaver<cr>', desc = 'Update fetchFromGitHub rev and hash' },
		},
		config = function(_, opts)
			require('nix-reaver').setup(opts)
		end,
	},
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
