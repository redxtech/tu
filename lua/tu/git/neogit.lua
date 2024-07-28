return {
	'neogit',
	cmd = 'Neogit',
	keys = {
		{ '<leader>gg', '<cmd>Neogit kind=replace<cr>', desc = 'Open Neogit' },
	},
	after = function(_)
		require('neogit').setup({
			-- don't scope persisted settings on a per-project basis
			use_per_project_settings = false,
			-- the time after which an output console is shown for slow running commands
			console_timeout = 4000,
		})
	end,
}
