return {
	'treesj',
	keys = {
		{ 'gm', '<cmd>TSJToggle<cr>', desc = 'Toggle Block' },
		{ 'gj', '<cmd>TSJJoin<cr>', desc = 'Join Block' },
		{ 'gp', '<cmd>TSJSplit<cr>', desc = 'Split Block' },
	},
	after = function(_)
		require('treesj').setup({
			use_default_keymap = false,
			max_join_length = 1000,
		})
	end,
}
