return {
	{
		'blink-nvim',
		keys = {
			{
				';',
				function()
					require('blink.chartoggle').toggle_char_eol(';')
				end,
				mode = { 'n', 'v' },
				desc = 'Toggle ; at eol',
			},
			{
				',',
				function()
					require('blink.chartoggle').toggle_char_eol(',')
				end,
				mode = { 'n', 'v' },
				desc = 'Toggle , at eol',
			},
			{ '<C-e>', '<cmd>BlinkTree reveal<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>E', '<cmd>BlinkTree toggle<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>e', '<cmd>BlinkTree toggle-focus<cr>', desc = 'Toggle file tree focus' },
		},
		after = function(_)
			require('blink').setup({
				chartoggle = { enabled = true },
				indent = { enabled = true },
				tree = { enabled = true },
			})
		end,
	},
	{
		'blink-cmp',
		enabled = false,
		after = function(_)
			require('blink').setup({ cmp = { enabled = true } })
		end,
	},
	{
		'nvim-snippets',
		after = function(_)
			require('snippets').setup({
				create_cmp_source = false,
				friendly_snippets = true,
			})
		end,
	},
	{
		'friendly-snippets',
	},
}
