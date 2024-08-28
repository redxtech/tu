return {
	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable dockerls server
			opts.servers.dockerls = {}
		end,
	},
}
