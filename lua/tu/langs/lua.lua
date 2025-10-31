-- enable lua_ls server
vim.lsp.config('lua_ls', {})
vim.lsp.enable('lua_ls')

return {
	-- used for completion, annotations and signatures of Neovim apis
	{
		'folke/lazydev.nvim',
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

	-- optional `vim.uv` typings
	{ 'Bilal2453/luvit-meta', lazy = true },
}
