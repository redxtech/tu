return {
	-- lsp
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable clangd server
			opts.servers.clangd = {}
		end,
	},

	{
		'stevearc/conform.nvim',
		name = 'conform-nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.c = { 'clang-format' }
			opts.formatters_by_ft.cpp = { 'clang-format' }
		end,
	},
}
