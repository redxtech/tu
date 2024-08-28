vim.api.nvim_create_user_command('FormatDisable', function(args)
	if args.bang then
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = 'Disable autoformat-on-save',
	bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = 'Re-enable autoformat-on-save',
})

return {
	-- configure linters and formatters
	{
		'stevearc/conform.nvim',
		name = 'conform-nvim',
		event = { 'BufWritePre' },
		cmd = { 'ConformInfo' },
		keys = {
			{
				'<leader>cf',
				function()
					require('conform').format({ async = true, lsp_fallback = true })
				end,
				mode = '',
				desc = '[F]ormat buffer',
			},
			{
				'<leader>cF',
				function()
					require('conform').format({ formatters = { 'injected' }, timeout_ms = 3000 })
				end,
				mode = { 'n', 'v' },
				desc = 'Format Injected Langs',
			},
			{
				'<leader>uf',
				function()
					if vim.g.disable_autoformat == true then
						vim.cmd('FormatEnable')
					else
						vim.cmd('FormatDisable')
					end
				end,
				desc = 'Toggle format on save',
			},
			{
				'<leader>uF',
				function()
					if vim.g.disable_autoformat == true then
						vim.cmd('FormatDisable!')
					else
						vim.cmd('FormatEnable')
					end
				end,
				desc = 'Toggle format on save',
			},
			{
				'<leader>ci',
				'<cmd>ConformInfo<cr>',
				desc = 'Conform Info',
			},
		},
		opts = {
			notify_on_error = true,
			default_format_opts = {
				timeout_ms = 3000,
				async = true,
				quiet = false,
				lsp_format = 'fallback',
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 500,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,
			formatters = {},
			formatters_by_ft = {},
		},
		config = function(_, opts)
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			require('conform').setup(opts)
		end,
	},
}
