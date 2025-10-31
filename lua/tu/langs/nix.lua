-- enable nil_ls server
vim.lsp.config('nil_ls', {})
vim.lsp.enable('nil_ls')

-- enable conform formatter
return {
	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.nix = {
				'nixfmt',
				-- 'alejandra',
			}
		end,
	},
}
