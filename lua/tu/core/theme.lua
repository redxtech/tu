return {
	{
		-- main theme
		'redxtech/dracula.nvim',
		name = 'dracula-nvim',
		lazy = false,
		priority = 1000,
		config = function(_, opts)
			local dracula = require('dracula')
			dracula.setup(opts)
			dracula.load()
		end,
		opts = {
			colors = {},
			show_end_of_buffer = true,
			transparent_bg = true,
			italic_comment = true,
			lualine_bg_color = '#44475a',
			overrides = function(colors)
				return {
					Normal = { bg = colors.bg },
					NotifyBackground = { bg = colors.bg },
					NeogitDiffAdd = { fg = colors.green, bg = '#003A00' },
					NeogitDiffAddHighlight = { fg = colors.bright_green, bg = '#003A00' },
					DiffviewDiffAdd = { fg = colors.green, bg = '#003A00' },

					BufferOffset = { fg = colors.bright_green, bg = colors.bg },
					BufferCurrentMod = { fg = colors.pink, bold = true },
				}
			end,
		},
	},

	-- recolor devicons to match theme
	{
		'rachartier/tiny-devicons-auto-colors.nvim',
		name = 'tiny-devicons-auto-colors-nvim',
		event = 'UIEnter',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function(_, opts)
			require('tiny-devicons-auto-colors').setup(opts)
		end,
	},
}
