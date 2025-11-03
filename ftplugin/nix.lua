-- enable nil_ls server
vim.lsp.config('nil_ls', {
	settings = {
		['nil'] = {
			formatting = { command = { 'nixfmt' } },
			nix = { flake = { autoEvalInputs = true } },
		},
	},
})
vim.lsp.enable('nil_ls')
