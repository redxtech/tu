return {
	'before',
	keys = {
		{
			'<Backspace>',
			'``',
			desc = 'Jump to last edit location',
		},
		{
			'<S-Backspace>',
			function()
				require('before').jump_to_last_edit()
			end,
			desc = 'Jump to previous entry in the edit history',
		},
		{
			'<leader>fe',
			function()
				require('before').show_edits_in_telescope()
			end,
			desc = 'Edited buffers',
		},
	},
	after = function(_)
		require('before').setup({})
	end,
}
