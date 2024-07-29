return {
	-- bufferline
	{
		'romgrk/barbar.nvim',
		name = 'barbar-nvim',
		event = 'VeryLazy',
		dependencies = { 'lewis6991/gitsigns.nvim', 'nvim-tree/nvim-web-devicons' },
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		config = function(_, opts)
			require('barbar').setup(opts)
		end,
		opts = {
			animation = true,
			auto_hide = false,
			focus_on_close = 'previous',
			insert_at_end = true,
			sidebar_filetypes = {
				['blink-tree'] = { text = 'File Tree' },
				['neo-tree'] = { event = 'BufWipeout' },
			},
		},
	},
}
