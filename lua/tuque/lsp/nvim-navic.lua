return {
	'nvim-navic',
	after = function(_)
		require('nvim-navic').setup({
			lsp = { auto_attach = true },
			highlight = true,
			click = false,
		})
	end,
}
