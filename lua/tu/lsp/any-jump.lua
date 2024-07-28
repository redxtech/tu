return {
	'any-jump',
	keys = {
		{ '<leader>j', '<cmd>AnyJump<cr>', desc = 'Grep References' },
	},
	before = function()
		vim.g.any_jump_disable_default_keybindings = 1
	end,
}
