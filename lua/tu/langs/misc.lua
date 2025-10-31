-- enable misc lsp servers
vim.lsp.config('buf_ls', {})
vim.lsp.config('dprint', { filetypes = { 'markdown', 'toml' } })
vim.lsp.config('hyprls', {})
vim.lsp.config('marksman', {})

vim.lsp.enable('buf_ls')
vim.lsp.enable('dprint')
vim.lsp.enable('hyprls')
vim.lsp.enable('marksman')

-- enable conform formatter
return {
	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.markdown = { 'markdownlint', 'dprint' }
			opts.formatters_by_ft.proto = { 'buf' }
			opts.formatters_by_ft.toml = { 'taplo' }
		end,
	},
}
