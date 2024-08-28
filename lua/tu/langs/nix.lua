return {
	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable nil_ls server
			opts.servers.nil_ls = {}
		end,
	},

	{
		'stevearc/conform.nvim',
		name = 'conform-nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.nix = {
				'nixfmt',
				-- 'alejandra',
			}
		end,
	},

	-- static linting
	{
		'oppiliappan/statix',
	},
}
