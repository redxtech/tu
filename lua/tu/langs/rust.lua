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
			-- NOTE: we shouldn't use this version, since the version
			-- will likely not match the version of the rust toolchain
			-- for whichever project we are working on.
			-- it's better to let rustaceanvim handle this.
			-- opts.servers.rust_analyzer = {}
		end,
	},

	{
		'stevearc/conform.nvim',
		name = 'conform-nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.rust = { 'rustfmt' }
		end,
	},
}
