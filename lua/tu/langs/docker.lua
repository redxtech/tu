return {
	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable dockerls server
			opts.servers.dockerls = {}

			-- tell efm to work with these filetypes
			table.insert(opts.servers.efm.filetypes, 'dockerfile')

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.dockerfile = {
				require('efmls-configs.linters.hadolint'),
			}
		end,
	},
}
