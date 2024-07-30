return {
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable bashls server
			opts.servers.bashls = {}
			-- opts.servers.fish_lsp = {}

			-- tell efm to work with these filetypes
			vim.list_extend(opts.servers.efm.filetypes, { 'bash', 'fish', 'sh' })

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.bash = {
				require('efmls-configs.linters.shellcheck'),
				require('efmls-configs.formatters.shfmt'),
			}
			opts.servers.efm.settings.languages.sh = {
				require('efmls-configs.linters.shellcheck'),
				require('efmls-configs.formatters.shfmt'),
			}
			opts.servers.efm.settings.languages.fish = {
				require('efmls-configs.formatters.fish_indent'),
			}
		end,
	},
}
