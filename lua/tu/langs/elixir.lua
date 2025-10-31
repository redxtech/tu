-- enable elixir lsp server
vim.lsp.config('lexical', {
	cmd = { 'lexical' },
})
vim.lsp.enable('lexical')

-- enable conform formatter
return {
	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.elixir = { 'mix' }
		end,
	},
}
