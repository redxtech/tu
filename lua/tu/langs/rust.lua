return {
	-- LSP + code actions
	{
		'mrcjkb/rustaceanvim',
	},

	-- formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable rust_analyzer server
			opts.servers.rust_analyzer = {}

			-- tell efm to work with these filetypes
			table.insert(opts.servers.efm.filetypes, 'rust')

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.rust = {
				require('efmls-configs.formatters.rustfmt'),
			}
		end,
	},
}
