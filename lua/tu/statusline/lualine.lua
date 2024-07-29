return {
	{
		'nvim-lualine/lualine.nvim',
		name = 'lualine-nvim',
		event = 'UIEnter',
		dependencies = { 'SmiteshP/nvim-navic' },
		config = function(_, opts)
			require('lualine').setup(opts)
		end,
		opts = function()
			local nerdtree = require('lualine.extensions.nerdtree')

			return {
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
			}
		end,
	},

	-- cursor context
	{
		'SmiteshP/nvim-navic',
		dependencies = { 'neovim/nvim-lspconfig' },
		opts = {
			lsp = { auto_attach = true },
			highlight = true,
			click = true,
		},
	},
}
