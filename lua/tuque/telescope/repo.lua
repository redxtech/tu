return {
	'telescope-repo-nvim',
	keys = {
		{ '<leader>fg', "<cmd>lua require'telescope'.extensions.repo.list{}<cr>", desc = 'Git Repositories' },
	},
	after = function(_)
		require('telescope').load_extension('repo')
	end,
}
