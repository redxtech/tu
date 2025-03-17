-- todo: uses biome when available, fallback to prettierd
local choose_formatter = function()
	local cwd = vim.fn.getcwd()
	local has_biome = vim.fn.filereadable(cwd .. '/biome.json')
	return has_biome == 1 and { 'biome' } or { 'prettierd' }
end

---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
	local conform = require('conform')
	for i = 1, select('#', ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

return {
	-- auto pairs for JSX
	{
		'windwp/nvim-ts-autotag',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = true,
	},

	-- linting/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable eslint, biome, and svelte servers
			opts.servers.biome = {}
			opts.servers.cssls = {}
			opts.servers.eslint = {}
			opts.servers.graphql = {}
			opts.servers.html = {}
			-- opts.servers.htmx = {}
			opts.servers.jsonls = {}
			opts.servers.svelte = {}
			opts.servers.tailwindcss = {}
			opts.servers.volar = {}
			opts.servers.vtsls = {}
		end,
	},

	{
		'stevearc/conform.nvim',
		opts = function(_, opts)
			local web_fmt = function(bufnr)
				return { 'eslint_d', first(bufnr, 'prettierd', 'prettier') }
			end

			opts.formatters_by_ft.javascript = web_fmt
			opts.formatters_by_ft.javascriptreact = web_fmt
			opts.formatters_by_ft.typescript = web_fmt
			opts.formatters_by_ft.typescriptreact = web_fmt
			opts.formatters_by_ft.css = web_fmt
			opts.formatters_by_ft.scss = web_fmt
			opts.formatters_by_ft.less = web_fmt
			opts.formatters_by_ft.html = web_fmt
			opts.formatters_by_ft.json = function(bufnr)
				return vim.list_extend(web_fmt(bufnr), { 'jq', 'fixjson' })
			end
			opts.formatters_by_ft.jsonc = web_fmt
			opts.formatters_by_ft.yaml = web_fmt
			opts.formatters_by_ft.graphql = web_fmt
			opts.formatters_by_ft.handlebars = web_fmt
			opts.formatters_by_ft.svelte = web_fmt
			opts.formatters_by_ft.vue = web_fmt
		end,
	},

	-- LSP

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
			require('lspconfig').vtsls.setup(opts)
		end,
	},
	-- provides TSC command and diagnostics in editor
	{ 'dmmulroy/tsc.nvim', event = 'VeryLazy' },
}
