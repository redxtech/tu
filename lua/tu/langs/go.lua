-- enable go lsp server
vim.lsp.config('gopls', {})
vim.lsp.enable('gopls')

-- enable conform formatter
return {
	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.go = { 'gofmt' }
		end,
	},
}
