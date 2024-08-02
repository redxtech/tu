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
		'figsoda/nix-develop.nvim',
		name = 'nix-develop-nvim',
		cmd = {
			'NixDevelop',
			'NixShell',
			'RiffShell',
		},
	},
	{
		'krivahtoo/silicon.nvim',
		name = 'silicon-nvim',
		cmd = 'Silicon',
		keys = {
			{ 'gss', ':Silicon<cr>', desc = 'Screenshot code', mode = 'v' },
		},
		config = function(_, opts)
			require('silicon').setup(opts)
		end,
		opts = function()
			local colors = require('dracula').colors()
			return {
				font = 'Iosevka Comfy',
				theme = 'Dracula',
				background = colors.menu,
				gobble = true,
				pad_horiz = 40,
				pad_vert = 40,
				tab_width = 2,
				shadow = {
					blur_radius = 15.0,
					color = colors.black,
				},
				window_title = function()
					return vim.fn.fnamemodify(vim.fn.bufname(vim.fn.bufnr()), ':~:.')
				end,
			}
		end,
	},
	-- markdown preview
	{
		'OXY2DEV/markview.nvim',
		name = 'markview-nvim',
		ft = 'markdown',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		keys = {
			{ '<leader>mv', '<cmd>Markview toggle<cr>', desc = 'Toggle markview for current buffer' },
		},
		config = function(_, opts)
			require('markview').setup(opts)
		end,
		opts = {
			code_blocks = {
				enable = true,
				style = 'language',
				position = 'overlay',
				hl = 'Layer1',
				pad_amount = 0,
				language_direction = 'right',
			},
		},
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
