return {
	'goto-preview',
	after = function(_)
		require('goto-preview').setup({
			default_mappings = true,
			-- resizing_mappings = true,
			references = {
				telescope = require('telescope.themes').get_dropdown({ hide_preview = false }),
			},
		})
	end,
}
