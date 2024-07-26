return {
	'barbar-nvim',
	before = function(_)
		vim.g.barbar_auto_setup = false
	end,
	after = function(_)
		require('barbar').setup({
			animation = true,
			auto_hide = false,
			focus_on_close = 'previous',
			insert_at_end = true,
			sidebar_filetypes = {
				['blink-tree'] = { text = 'File Tree' },
				['neo-tree'] = { event = 'BufWipeout' },
			},
		})
	end,
}
