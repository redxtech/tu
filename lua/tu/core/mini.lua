return {
	'mini-nvim',
	after = function(_)
		require('mini.bufremove').setup()
		require('mini.cursorword').setup()
		require('mini.pairs').setup()

		require('mini.surround').setup({
			n_lines = 50,
			mappings = {
				add = 'gsa', -- Add surrounding in Normal and Visual modes
				delete = 'gsd', -- Delete surrounding
				find = 'gsf', -- Find surrounding (to the right)
				find_left = 'gsF', -- Find surrounding (to the left)
				highlight = 'gsh', -- Highlight surrounding
				replace = 'gsr', -- Replace surrounding
			},
		})
	end,
	keys = {
		-- surround
		{ 'gsa', desc = 'Add surrounding', mode = { 'n', 'v' } },
		{ 'gsd', desc = 'Delete surrounding' },
		{ 'gsf', desc = 'Find right surrounding' },
		{ 'gsF', desc = 'Find left surrounding' },
		{ 'gsh', desc = 'Highlight surrounding' },
		{ 'gsr', desc = 'Replace surrounding' },

		-- bufremove
		{
			'<leader>bd',
			function()
				local bd = require('mini.bufremove').delete
				if vim.bo.modified then
					local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
					if choice == 1 then -- Yes
						vim.cmd.write()
						bd(0)
					elseif choice == 2 then -- No
						bd(0, true)
					end
				else
					bd(0)
				end
			end,
			desc = 'Delete Buffer',
		},
		{
			'<leader>bD',
			function()
				require('mini.bufremove').delete(0, true)
			end,
			desc = 'Delete Buffer (Force)',
		},
	},
}
