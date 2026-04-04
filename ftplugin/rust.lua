vim.g.rustaceanvim = {
	server = {
		default_settings = {
			['rust-analyzer'] = {
				-- build in sub directory to prevent locking
				cargo = { targetDir = true },
			},
		},
	},
}
