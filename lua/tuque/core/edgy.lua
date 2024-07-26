return {
	'edgy.nvim',
	after = function(_)
		require('edgy').setup({
			animate = { enabled = false },
			icons = {
				closed = '',
				open = '',
			},
			wo = { winbar = false },
			options = {
				left = { size = 40 },
				right = { size = 80 },
			},
			bottom = {
				'Trouble',
				{ ft = 'qf', title = 'QuickFix' },
				{
					ft = 'toggleterm',
					-- exclude floating windows
					filter = function(_, win)
						return vim.api.nvim_win_get_config(win).relative == ''
					end,
				},
				{
					ft = 'help',
					size = { height = 20 },
					-- only show help buffers
					filter = function(buf)
						return vim.bo[buf].buftype == 'help'
					end,
				},
			},
			left = {
				{ ft = 'blink-tree' },
				{ ft = 'neo-tree' },
			},
			right = {},
		})
	end,
}
