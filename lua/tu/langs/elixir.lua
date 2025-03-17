return {
	-- linting/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable gopls  server
			opts.servers.lexical = {
				cmd = { 'lexical' },
			}
		end,
	},

	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.elixir = { 'mix' }
		end,
	},
}
