return {
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable bashls server
			opts.servers.bashls = {}
			-- opts.servers.fish_lsp = {}
		end,

		{
			'stevearc/conform.nvim',
			opts = function(_, opts)
				opts.formatters_by_ft.bash = { 'shellcheck', 'shellharden', 'shfmt' }
				opts.formatters_by_ft.sh = { 'shellcheck', 'shellharden', 'shfmt' }
				opts.formatters_by_ft.fish = { 'fish_indent' }
			end,
		},
	},
}
