-- NOTE: we shouldn't use this version, since the version
-- will likely not match the version of the rust toolchain
-- for whichever project we are working on.
-- it's better to let rustaceanvim handle this.

-- enable rust_analyzer server
-- vim.lsp.config('rust_analyzer', {})
-- vim.lsp.enable('rust_analyzer')

return {
	-- LSP + code actions
	{
		'mrcjkb/rustaceanvim',
	},

	{
		'saecki/crates.nvim',
		ft = 'toml',
		opts = {
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
			completion = {
				crates = { enabled = true },
			},
		},
	},

	-- formatting
	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.rust = { 'rustfmt' }
		end,
	},
}
