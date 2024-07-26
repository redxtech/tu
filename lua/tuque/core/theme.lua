return {
	-- main theme
	'dracula',
	lazy = false,
	priority = 1000,
	after = function(_)
		local dracula = require('dracula')
		dracula.setup({
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
		})
		dracula.load()
	end,
}
