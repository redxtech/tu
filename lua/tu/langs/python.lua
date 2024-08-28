return {
	-- pick venv (supports all major managers)
	{
		'linux-cultist/venv-selector.nvim',
		name = 'venv-selector-nvim',
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
		config = function(_, opts)
			require('venv-selector').setup(opts)
		end,
	},

	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable pyright and ruff_lsp servers
			opts.servers.basedpyright = {}
			opts.servers.ruff = {}
		end,
	},

	{
		'stevearc/conform.nvim',
		name = 'conform-nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.python = { 'ruff_format', 'ruff_organize_imports', 'black' }
		end,
	},
}
