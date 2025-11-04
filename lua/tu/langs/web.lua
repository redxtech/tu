-- enable web lsp servers
local servers = {
	'biome',
	'cssls',
	'eslint',
	'graphql',
	'html',
	'jsonls',
	'svelte',
	'tailwindcss',
}
vim.lsp.enable(servers)

return {
	-- auto pairs for JSX
	{
		'windwp/nvim-ts-autotag',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = true,
	},

	-- performs drastically better than tsserver because we can limit the number of entries
	-- todo: shows symbols from node_modules, mitigated via telescope
	{
		'yioneko/nvim-vtsls',
		event = 'VeryLazy',
		config = function()
			local opts = require('vtsls').lspconfig
			local tsserver_filetypes =
				{ 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'vue' }
			local vue_plugin = { name = '@vue/typescript-plugin', languages = { 'vue' }, configNamespace = 'typescript' }
			local vue_ls_config = {
				settings = {
					css = { validate = true, lint = { unknownAtRules = 'ignore' } },
					scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
					less = { validate = true, lint = { unknownAtRules = 'ignore' } },
				},
			}

			opts.settings = {
				typescript = {
					preferences = { preferTypeOnlyAutoImports = true },
					workspaceSymbols = { scope = 'currentProject', excludeLibrarySymbols = true },
					tsserver = { globalPlugins = { vue_plugin } },
				},
				vtsls = {
					autoUseWorkspaceTsdk = true,
					experimental = { completion = { enableServerSideFuzzyMatch = true, entriesLimit = 75 } },
					tsserver = { globalPlugins = { vue_plugin } },
				},
			}

			opts.filetypes = tsserver_filetypes

			vim.lsp.config('vtsls', opts)
			vim.lsp.config('vue_ls', vue_ls_config)

			vim.lsp.enable({ 'vtsls', 'vue_ls' })
		end,
	},

	-- provides TSC command and diagnostics in editor
	{ 'dmmulroy/tsc.nvim', event = 'VeryLazy' },
}
