-- enable web lsp servers
for _, server in ipairs({
	'biome',
	'cssls',
	'eslint',
	'graphql',
	'html',
	'jsonls',
	'svelte',
	'tailwindcss',
	'volar',
	-- 'vtsls' -- enabled below
}) do
	vim.lsp.config(server, {})
	vim.lsp.enable(server)
end

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
			opts.settings = {
				typescript = {
					preferences = {
						preferTypeOnlyAutoImports = true,
					},
					workspaceSymbols = {
						scope = 'currentProject',
						excludeLibrarySymbols = true,
					},
					tsserver = {
						pluginPaths = {
							-- requires: npm i -g @styled/typescript-styled-plugin typescript-styled-plugin
							-- TODO: Install with mason or some other way
							'~/.local/share/npm/lib/node_modules/@styled/typescript-styled-plugin',
						},
					},
				},
				vtsls = {
					autoUseWorkspaceTsdk = true,
					experimental = {
						completion = {
							-- enableServerSideFuzzyMatch = true,
							-- entriesLimit = 75,
						},
					},
				},
			}
			vim.lsp.config('vtsls', opts)
			vim.lsp.enable('vtsls')
		end,
	},
	-- provides TSC command and diagnostics in editor
	{ 'dmmulroy/tsc.nvim', event = 'VeryLazy' },
}
