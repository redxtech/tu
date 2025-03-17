return {
	-- lsp
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable bufls and marksman servers
			opts.servers.buf_ls = {}
			opts.servers.dprint = { filetypes = { 'markdown', 'toml' } }
			opts.servers.hyprls = {}
			opts.servers.marksman = {}
			-- opts.servers.remark_ls = {} -- TODO: look into remark
		end,
	},

	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			opts.formatters_by_ft.markdown = { 'markdownlint', 'dprint' }
			opts.formatters_by_ft.proto = { 'buf' }
			opts.formatters_by_ft.toml = { 'taplo' }
		end,
	},
}
