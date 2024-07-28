return {
	'nvim-treesitter',
	event = 'BufEnter',
	after = function(_)
		require('nvim-treesitter.configs').setup({
			-- todo: slow on typescript files?
			highlight = {
				-- only enable if we're not profiling
				enable = os.getenv('NVIM_PROFILE') == nil,
				disable = { 'nix', 'python', 'go', 'lua' },
			},
			indent = { enable = false },
			incremental_selection = {
				enable = true,
				keymaps = {
					node_incremental = 'v',
					node_decremental = 'V',
				},
			},
			textobjects = {
				move = {
					enable = false,
				},
			},

			modules = {},

			auto_install = false,
			sync_install = true,
			ignore_install = {},
			ensure_installed = {},
		})
	end,
}
