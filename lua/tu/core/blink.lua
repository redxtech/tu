local map_blink_chartoggle = function(char)
	return {
		char,
		function()
			require('blink.chartoggle').toggle_char_eol(char)
		end,
		mode = { 'n', 'v' },
		desc = 'Toggle ' .. char .. ' at eol',
	}
end

return {
	{
		'saghen/blink.cmp',
		lazy = false,
		dependencies = { 'rafamadriz/friendly-snippets' },
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = 'super-tab',
			},
			sources = {
				-- TODO: add more sources: env, rg, conventionalcommits, etc.
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},
			appearance = {
				nerd_font_variant = 'normal',
			},
			-- experimental signature help support
			signature = { enabled = true },
		},
	},
	{
		'saghen/blink.pairs',
		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
		opts = {
			mappings = {
				enabled = true,
			},
			highlights = {
				enabled = true,
				groups = {
					'RainbowCyan',
					'RainbowGreen',
					'RainbowPink',
					'RainbowOrange',
				},
			},
		},
	},
	{
		'saghen/blink.nvim',
		-- dev = true,
		lazy = false,
		dependencies = {
			{
				'garymjr/nvim-snippets',
				dependencies = { 'rafamadriz/friendly-snippets' },
				opts = { create_cmp_source = false, friendly_snippets = true },
			},
		},
		keys = {
			-- char toggle
			map_blink_chartoggle(';'),
			map_blink_chartoggle(','),

			-- tree
			{ '<C-e>', '<cmd>BlinkTree reveal<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>E', '<cmd>BlinkTree toggle<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>e', '<cmd>BlinkTree toggle-focus<cr>', desc = 'Toggle file tree focus' },
		},
		opts = {
			chartoggle = { enabled = true },
			cmp = { enabled = false },
			indent = { enabled = true },
			tree = {
				enabled = true,
				hidden_by_default = true,
				hide_dotfiles = false,
				hide = {
					'.github',
				},
				never_show = {
					'.git',
					'.cache',
					'.direnv',
					'.devenv',
					'.pytest_cache',
					'.ruff_cache',
					'.venv',
					'__pycache__',
					'node_modules',
				},
			},
		},
	},
}
