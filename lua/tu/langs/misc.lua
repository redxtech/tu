return {
	-- lsp
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable bufls and marksman servers
			opts.servers.bufls = {}
			opts.servers.dprint = {}
			opts.servers.hyprls = {}
			opts.servers.marksman = {}
			opts.servers.remark_ls = {} -- TODO: look into remark

			-- tell efm to work with these filetypes
			vim.list_extend(opts.servers.efm.filetypes, {
				'markdown',
				'toml',
			})

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.markdown = {
				require('efmls-configs.linters.markdownlint'),
				require('efmls-configs.formatters.dprint'),
			}

			opts.servers.efm.settings.languages.proto = {
				require('efmls-configs.linters.buf'),
				require('efmls-configs.formatters.buf'),
			}

			opts.servers.efm.settings.languages.toml = {
				require('efmls-configs.formatters.dprint'),
			}
		end,
	},
}
