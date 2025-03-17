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
	{ 'tenxsoydev/tabs-vs-spaces.nvim' },
	{
		'stevearc/oil.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		keys = {
			{ '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
		},
		opts = {
			columns = { 'icon', 'size' },
			delete_to_trash = true,
		},
	},
	{ 'nkakouros-original/scrollofffraction.nvim', event = 'BufEnter' },
	{
		'redxtech/nix-reaver.nvim',
		keys = {
			{ '<leader>ur', ':NixReaver<cr>', desc = 'Update fetchFromGitHub rev and hash' },
		},
	},
	{
		'figsoda/nix-develop.nvim',
		cmd = {
			'NixDevelop',
			'NixShell',
			'RiffShell',
		},
	},
	{
		'krivahtoo/silicon.nvim',
		cmd = 'Silicon',
		keys = {
			{ 'gss', ':Silicon<cr>', desc = 'Screenshot code', mode = 'v' },
		},
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
	{
		'sontungexpt/url-open',
		cmd = 'URLOpenUnderCursor',
		keys = { { 'gx', '<cmd>URLOpenUnderCursor<cr>' } },
		config = true,
	},
	{
		'sQVe/sort.nvim',
		keys = {
			sortMap('', 'v'),
			sortMap('"'),
			sortMap("'"),
			sortMap('('),
			sortMap('['),
			sortMap('{'),
			sortMap('p'),
		},
	},
	{
		'max397574/better-escape.nvim',
	},
	{
		'willothy/moveline.nvim',
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
	-- screenkey
	{
		'NStefan002/screenkey.nvim',
		cmd = 'Screenkey',
		keys = {
			{ '<leader>sK', '<cmd>Screenkey<cr>', desc = 'Toggle Screenkey' },
		},
	},
}
