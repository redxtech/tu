return {
	-- linting/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable gopls  server
			opts.servers.gopls = {}
		end,
	},

	{
		'stevearc/conform.nvim',
		name = 'conform-nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.go = { 'gofmt' }
		end,
	},
}
