return {
	-- linting/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable denols server
			opts.servers.denols = {}

			-- tell efm to work with these filetypes
			table.insert(opts.servers.efm.filetypes, 'typescript')

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.typescript = {
				require('efmls-configs.formatters.deno_fmt'),
			}
		end,
	},
}
