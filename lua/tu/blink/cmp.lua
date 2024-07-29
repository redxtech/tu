--- @param mode string|string[] modes to map
--- @param lhs string lhs
--- @param rhs string rhs
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
		dev = true,
		event = 'InsertEnter',
		build = 'cargo build --release',
		dependencies = {
			{
				'garymjr/nvim-snippets',
				dependencies = { 'rafamadriz/friendly-snippets' },
				opts = { create_cmp_source = false, friendly_snippets = true },
			},
		},
		keys = {
			map_blink_cmp('i', '<C-space>', 'show'),
			map_blink_cmp('i', '<Tab>', 'accept'),
			map_blink_cmp('i', '<Up>', 'select_prev'),
			map_blink_cmp('i', '<Down>', 'select_next'),
			map_blink_cmp('i', '<C-k>', 'select_prev'),
			map_blink_cmp('i', '<C-j>', 'select_next'),
		},
		opts = {
			cmp = { enabled = true },
		},
		config = function(_, opts)
			require('blink.cmp').setup(opts)
		end,
	},
}
