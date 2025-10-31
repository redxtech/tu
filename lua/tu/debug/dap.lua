return {
	{ 'mfussenegger/nvim-dap' },

	-- TODO: breaks <CR>
	-- TODO: cursor doesn't update when in debug mode moving from tree to code
	-- TODO: look at saghen/nvim after a bit (https://github.com/saghen/nvim/blob/main/lua/core/debug.lua)
	{
		'miroshQa/debugmaster.nvim',
		enabled = false,
		dependencies = { 'mfussenegger/nvim-dap' },
		event = 'VeryLazy',
		config = function()
			local dm = require('debugmaster')
			vim.keymap.set({ 'n', 'v' }, '<leader>d', dm.mode.toggle, { nowait = true })
			vim.keymap.set('n', '<Esc>', dm.mode.disable)
			-- This might be unwanted if you already use Esc for ":noh"
			vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

			local dap = require('dap')
			-- Configure your debug adapters here
			-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
		end,
	},
}
