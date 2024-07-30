return {
	-- linting/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable gopls  server
			opts.servers.gopls = {}

			-- tell efm to work with these filetypes
			table.insert(opts.servers.efm.filetypes, 'go')

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.go = {
				require('efmls-configs.linters.golangci_lint'),
				require('efmls-configs.formatters.gofmt'),
			}
		end,
	},
}
