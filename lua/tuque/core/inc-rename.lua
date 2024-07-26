return {
	-- live feedback for rename
	'inc-rename-nvim',
	cmd = 'IncRename',
	keys = {
		{
			'<leader>cr',
			function()
				return ':IncRename ' .. vim.fn.expand('<cword>')
			end,
			expr = true,
			desc = 'Rename',
		},
	},
	after = function(_)
		require('inc_rename').setup({})
	end,
}
