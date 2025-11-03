return {
	{
		'folke/flash.nvim',
		---@type Flash.Config
		-- stylua: ignore
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x", "n" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},

	-- better motions for b, w, e
	{
		'chrisgrieser/nvim-spider',
		event = 'BufEnter',
		keys = {
			{ 'w', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
			{ 'e', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
			{ 'b', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
		},
	},

	-- navigate with navic elements
	{
		'SmiteshP/nvim-navbuddy',
		dependencies = {
			'neovim/nvim-lspconfig',
			'SmiteshP/nvim-navic',
			'MunifTanjim/nui.nvim',
			'nvim-telescope/telescope.nvim',
			-- 'numToStr/Comment.nvim', -- Optional
		},
		cmd = { 'Navbuddy' },
		keys = { { '<leader>nv', '<cmd>Navbuddy<cr>', desc = 'Navigate' } },
		opts = { lsp = { auto_attach = true } },
	},
}
