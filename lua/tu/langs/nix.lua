return {
	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable nil_ls and statix servers
			opts.servers.nil_ls = {}
			-- opts.servers.statix = {}

			-- tell efm to work with these filetypes
			table.insert(opts.servers.efm.filetypes, 'nix')

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.nix = {
				require('efmls-configs.formatters.nixfmt'),
				require('efmls-configs.linters.statix'),
				-- require('efmls-configs.formatters.alejandra'),
			}
		end,
	},
}
