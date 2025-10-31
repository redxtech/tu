-- enable pyright & ruff servers
vim.lsp.config('basedpyright', {})
vim.lsp.config('ruff', {})

vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')

return {
	-- pick venv (supports all major managers)
	{
		'linux-cultist/venv-selector.nvim',
		branch = 'regexp',
		cmd = 'VenvSelect',
		opts = {
			-- todo: custom queries and disable built in because slow
			-- todo: hook into sessions to auto load venv
			-- todo: requires manually restarting LSPs so should happen automatically
			settings = {
				search = {
					root = {
						command = 'echo ~/.venv/bin/python',
					},
				},
			},
		},
		keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv' } },
	},
}
