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
		'saghen/blink-nvim',
		name = 'blink-nvim',
		-- dev = true,
		lazy = false,
		cmd = 'BlinkTree',
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
			indent = { enabled = true },
			tree = { enabled = true },
		},
		config = function(_, opts)
			require('blink').setup(opts)
		end,
	},
}
