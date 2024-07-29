return {
	-- treesitter
	-- {
	-- 	'nvim-treesitter/nvim-treesitter',
	-- 	opts = function(_, opts)
	-- 		if type(opts.ensure_installed) == 'table' then
	-- 			vim.list_extend(opts.ensure_installed, {
	-- 				'lua',
	-- 				'luadoc',
	-- 				'luap',
	-- 			})
	-- 		end
	-- 	end,
	-- },

	-- used for completion, annotations and signatures of Neovim apis
	{
		'folke/lazydev.nvim',
		name = 'lazydev-nvim',
		ft = 'lua',
		opts = {
			library = {
				-- adds type hints for nixCats global
				{
					path = require('nixCats').nixCatsPath .. '/lua',
					words = { 'nixCats' },
				},
				{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
			},
		},
	},
	{ 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
	{
		'neovim/nvim-lspconfig',
		dependencies = { { 'creativenull/efmls-configs-nvim', name = 'efmls-configs-nvim' } },
		opts = function(_, opts)
			table.insert(opts.servers.efm.filetypes, 'lua')
			opts.servers.efm.settings.languages.lua = {
				require('efmls-configs.formatters.stylua'),
				-- require('efmls-configs.formatters.stylua'),
			}
			opts.servers.lua_ls = {}
		end,
	},
}
