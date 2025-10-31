-- format on save
vim.api.nvim_create_autocmd('BufWritePre', {
	desc = 'Format on save',
	pattern = '*',
	callback = function(args)
		if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].buftype ~= '' then
			return
		end
		if vim.g.disable_autoformat then
			return
		end
		vim.lsp.buf.format({
			filter = function(client)
				return vim.tbl_contains({
					'efm',
					'dprint',
					'gopls',
					'lua_ls',
					'terraformls',
					'rust-analyzer',
					'nil_ls',
					'stylua',
				}, client.name)
			end,
		})
	end,
})

return {
	{
		'creativenull/efmls-configs-nvim',
		dependencies = { 'neovim/nvim-lspconfig' },
		lazy = false,
		keys = {
			{
				'<leader>cf',
				function()
					vim.lsp.buf.format({
						filter = function(client)
							return client.name == 'efm'
						end,
					})
				end,
				desc = 'Format',
				mode = { 'n', 'v' },
			},
			{
				'<leader>uf',
				function()
					if vim.g.disable_autoformat == nil then
						vim.g.disable_autoformat = true
						vim.notify('format on save disabled')
					else
						vim.g.disable_autoformat = not vim.g.disable_autoformat
						vim.notify('format on save ' .. (vim.g.disable_autoformat and 'enabled' or 'disabled'))
					end
				end,
				desc = 'Toggle format on save',
			},
		},
		config = function()
			local set_tool = function(lang, tools, type)
				local tool_configs = {}
				for _, tool in ipairs(tools) do
					table.insert(tool_configs, require('efmls-configs.' .. type .. 's.' .. tool))
				end

				vim.lsp.config('efm', {
					settings = {
						languages = {
							[lang] = tool_configs,
						},
					},
				})
			end

			set_tool('bash', { 'shellcheck' }, 'linter')
			set_tool('fish', { 'fish' }, 'linter')
			set_tool('json', { 'jq' }, 'linter')
			set_tool('proto', { 'buf' }, 'linter')
			set_tool('python', { 'ruff' }, 'linter')
			set_tool('markdown', { 'markdownlint', 'proselint' }, 'linter')
			set_tool('sh', { 'shellcheck' }, 'linter')

			set_tool('bash', { 'shfmt' }, 'formatter')
			set_tool('elixir', { 'mix' }, 'formatter')
			set_tool('fish', { 'fish_indent' }, 'formatter')
			set_tool('go', { 'gofmt' }, 'formatter')
			set_tool('json', { 'jq' }, 'formatter')
			set_tool('lua', { 'stylua' }, 'formatter')
			set_tool('markdown', { 'dprint' }, 'formatter')
			set_tool('python', { 'ruff', 'ruff_sort' }, 'formatter')
			set_tool('rust', { 'rustfmt' }, 'formatter')
			set_tool('sh', { 'shellharden', 'shfmt' }, 'formatter')
			set_tool('terraform', { 'terraform_fmt' }, 'formatter')
			set_tool('terraform-vars', { 'terraform_fmt' }, 'formatter')
			set_tool('tf', { 'terraform_fmt' }, 'formatter')
			set_tool('toml', { 'taplo' }, 'formatter')

			-- stylua: ignore
			local languages = {
				'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
				'css', 'scss', 'less', 'html',
				'json', 'jsonc', 'yaml', 'graphql', 'svelte', 'vue',
			}

			local has_biome = vim.fn.filereadable(vim.fn.getcwd() .. '/biome.json')
			local web_formatters = has_biome == 1 and { 'biome' } or { 'prettier_d' }
			for _, lang in ipairs(languages) do
				set_tool(lang, web_formatters, 'formatter')
			end

			-- enable efm formatting for all filetypes
			vim.lsp.config('efm', {
				cmd = { 'efm-langserver' },
				filetypes = vim.tbl_keys(vim.lsp.config.efm.settings.languages),
				root_markers = { '.git' },
				init_options = { documentFormatting = true, documentRangeFormatting = true },
			})
			vim.lsp.enable('efm')
		end,
	},
}
