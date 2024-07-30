return {
	-- lsp
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable clangd server
			opts.servers.clangd = {}

			-- tell efm to work with these filetypes
			vim.list_extend(opts.servers.efm.filetypes, { 'c', 'cpp' })

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.c = {
				require('efmls-configs.linters.clang_tidy'),
				require('efmls-configs.formatters.clang_tidy'),
				-- require('efmls-configs.formatters.clang_format')
			}

			opts.servers.efm.settings.languages.cpp = {
				require('efmls-configs.linters.clang_tidy'),
				require('efmls-configs.formatters.clang_tidy'),
				-- require('efmls-configs.formatters.clang_format')
			}
		end,
	},
}
