return {
	'lualine-nvim',
	event = 'UIEnter',
	after = function(_)
		local nerdtree = require('lualine.extensions.nerdtree')

		require('lualine').setup({
			options = {
				theme = 'dracula-nvim',
				globalstatus = true,
				disabled_filetypes = { 'dashboard' },
			},
			sections = {
				lualine_b = { 'branch', 'diagnostics' },
				lualine_x = {
					'filesize',
					'encoding',
					'fileformat',
					{
						'filetype',
						icon = { align = 'right' },
					},
				},
				lualine_y = {
					'selectioncount',
					'progress',
				},
			},
			extensions = {
				'lazy',
				'man',
				'overseer',
				'toggleterm',
				'trouble',
				{
					sections = vim.deepcopy(nerdtree.sections),
					filetypes = { 'blink-tree' },
				},
			},
		})
	end,
}
