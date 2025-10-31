-- enable bashls server
vim.lsp.config('bashls', {})
vim.lsp.enable('bashls')

-- enable conform formatter
return {
	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.bash = { 'shellcheck', 'shellharden', 'shfmt' }
			opts.formatters_by_ft.sh = { 'shellcheck', 'shellharden', 'shfmt' }
			opts.formatters_by_ft.fish = { 'fish_indent' }
		end,
	},
}
