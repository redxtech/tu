-- todo: uses biome when available, fallback to prettierd
local choose_formatter = function()
	local cwd = vim.fn.getcwd()
	local has_biome = vim.fn.filereadable(cwd .. '/biome.json')
	return has_biome == 1 and { 'biome' } or { 'prettierd' }
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
			-- opts.servers.vtsls = {}

			-- tell efm to work with these filetypes
			vim.list_extend(opts.servers.efm.filetypes, {
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
				'css',
				'scss',
				'less',
				'html',
				'json',
				'jsonc',
				'yaml',
				'graphql',
				'handlebars',
				'svelte',
				'vue',
			})

			-- choose efm formatters and linters
			-- local biome = require('efmls-configs.formatters.biome')
			local eslint_d_lint = require('efmls-configs.linters.eslint_d')
			local eslint_d_fmt = require('efmls-configs.formatters.eslint_d')
			local prettierd = require('efmls-configs.formatters.prettier_d')

			local web_efm = {
				eslint_d_lint,
				eslint_d_fmt,
				prettierd,
			}

			opts.servers.efm.settings.languages.javascript = web_efm
			opts.servers.efm.settings.languages.javascriptreact = web_efm
			opts.servers.efm.settings.languages.typescript = web_efm
			opts.servers.efm.settings.languages.typescriptreact = web_efm
			opts.servers.efm.settings.languages.css = web_efm
			opts.servers.efm.settings.languages.scss = web_efm
			opts.servers.efm.settings.languages.less = web_efm
			opts.servers.efm.settings.languages.html = web_efm
			opts.servers.efm.settings.languages.json = {
				require('efmls-configs.linters.jq'),
				require('efmls-configs.formatters.fixjson'),
				eslint_d_lint,
				eslint_d_fmt,
				prettierd,
			}
			opts.servers.efm.settings.languages.jsonc = web_efm
			opts.servers.efm.settings.languages.yaml = web_efm
			opts.servers.efm.settings.languages.graphql = web_efm
			opts.servers.efm.settings.languages.handlebars = web_efm
			opts.servers.efm.settings.languages.svelte = web_efm
			opts.servers.efm.settings.languages.vue = web_efm
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
	-- TODO: install with nix
	{ 'williamboman/mason.nvim', opts = { ensure_installed = { vtsls = {} } } },
	-- provides TSC command and diagnostics in editor
	{
		'dmmulroy/tsc.nvim',
		name = 'tsc-nvim',
		event = 'VeryLazy',
		config = function(_, opts)
			require('tsc').setup(opts)
		end,
	},
}
