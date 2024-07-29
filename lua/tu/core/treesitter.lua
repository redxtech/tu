return {
	'nvim-treesitter/nvim-treesitter',
	event = 'BufRead',
	build = require('nixCatsUtils').lazyAdd(':TSUpdate'),
	---@type TSConfig
	---@diagnostic disable-next-line: missing-fields
	opts = {
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
	},
	config = function(_, opts)
		require('nvim-treesitter.configs').setup(opts)
	end,
}
