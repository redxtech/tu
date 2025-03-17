return {
	-- used for completion, annotations and signatures of Neovim apis
	{
		'folke/lazydev.nvim',
		ft = 'lua',
		opts = {
			library = {
				-- adds type hints for nixCats global
				{
					path = require('nixCats').nixCatsPath .. '/lua',
					words = { 'nixCats' },
				},
				{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
			},
		},
	},

	-- optional `vim.uv` typings
	{ 'Bilal2453/luvit-meta', lazy = true },

	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable lua_ls server
			opts.servers.lua_ls = {}
		end,
	},

	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.lua = { 'stylua' }
		end,
	},
}
