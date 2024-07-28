return {
	'nvim-spectre',
	keys = {
		{ '<leader>H', '<cmd>lua require("spectre").toggle()<cr>', desc = 'Find and Replace (Workspace)' },
	},
	after = function(_)
		require('spectre').setup({
			is_insert_mode = true, -- open in insert mode
			live_update = true, -- execute search query immediately
			lnum_for_results = false, -- show line number for search/replace results
			-- disable borders
			line_sep_start = '',
			result_padding = '',
			line_sep = '',
			-- invert colors
			highlight = {
				ui = 'Primary',
				filename = 'Primary',
				-- todo: change these in theme?
				search = 'DiffDelete',
				replace = 'DiffAdd',
			},
		})
	end,
}
