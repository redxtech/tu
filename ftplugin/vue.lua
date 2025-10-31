-- enable vue lsp server
vim.lsp.config('volar', {
	settings = {
		css = { validate = true, lint = { unknownAtRules = 'ignore' } },
		scss = { validate = true, lint = { unknownAtRules = 'ignore' } },
		less = { validate = true, lint = { unknownAtRules = 'ignore' } },
	},
})
vim.lsp.enable('volar')
