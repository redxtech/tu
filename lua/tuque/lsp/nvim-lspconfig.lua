return {
	'nvim-lspconfig',
	priority = 1000,
	event = 'BufEnter',
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
				else
					vim.g.disable_autoformat = not vim.g.disable_autoformat
				end
			end,
			desc = 'Toggle format on save',
		},
	},
	after = function(_)
		local lspconfig = require('lspconfig')
		local opts = {
			servers = {
				dockerls = {},
				nil_ls = {},
				efm = {
					filetypes = {
						'lua',
						'nix',
					},
					settings = {
						version = 2,
						rootMarkers = { '.git/' },
						languages = {
							lua = require('efmls-configs.formatters.stylua'),
							nix = require('efmls-configs.formatters.nixfmt'),
						},
					},
					init_options = {
						documentFormatting = true,
						documentRangeFormatting = true,
					},
				},
			},
		}

		for server, config in pairs(opts.servers) do
			lspconfig[server].setup(config)
		end
	end,
}
