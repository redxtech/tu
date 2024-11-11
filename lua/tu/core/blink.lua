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

local function map_blink_cmp(mode, lhs, rhs)
	return {
		lhs,
		function()
			local did_run = require('blink.cmp')[rhs]()
			if not did_run then
				return lhs
			end
		end,
		mode = mode,
		expr = true,
		noremap = true,
		silent = true,
		replace_keycodes = true,
	}
end

return {
	{
		'saghen/blink.cmp',
		name = 'blink-cmp',
		build = 'cargo build --release',
		lazy = false,
		dependencies = { 'rafamadriz/friendly-snippets' },
		keys = {
			map_blink_cmp('i', '<C-space>', 'show'),
			map_blink_cmp('i', '<Tab>', 'accept'),
			map_blink_cmp('i', '<Up>', 'select_prev'),
			map_blink_cmp('i', '<Down>', 'select_next'),
			map_blink_cmp('i', '<C-k>', 'select_prev'),
			map_blink_cmp('i', '<C-j>', 'select_next'),
		},
		opts = {
			highlight = {
				use_nvim_cmp_as_default = true,
			},
			-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- adjusts spacing to ensure icons are aligned
			nerd_font_variant = 'normal',

			-- experimental auto-brackets support
			accept = { auto_brackets = { enabled = true } },

			-- experimental signature help support
			trigger = { signature_help = { enabled = true } },
		},
		config = function(_, opts)
			require('blink.cmp').setup(opts)
		end,
	},
	{
		'saghen/blink.nvim',
		name = 'blink-nvim',
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
		config = function(_, opts)
			require('blink').setup(opts)
		end,
	},
}
