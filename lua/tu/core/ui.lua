return {
	-- buffer winbar replacement
	{
		'b0o/incline.nvim',
		event = 'VeryLazy',
		opts = {
			window = {
				padding = 0,
				margin = { horizontal = 0 },
			},
			render = function(props)
				local devicons = require('nvim-web-devicons')

				-- Filename
				local buf_path = vim.api.nvim_buf_get_name(props.buf)
				local dirname = vim.fn.fnamemodify(buf_path, ':~:.:h')
				local dirname_component = { dirname, group = 'Comment' }

				local filename = vim.fn.fnamemodify(buf_path, ':t')
				if filename == '' then
					filename = '[No Name]'
				end
				local diagnostic_level = nil
				for _, diagnostic in ipairs(vim.diagnostic.get(props.buf)) do
					diagnostic_level = math.min(diagnostic_level or 999, diagnostic.severity)
				end
				local filename_hl = diagnostic_level == vim.diagnostic.severity.HINT and 'DiagnosticHint'
					or diagnostic_level == vim.diagnostic.severity.INFO and 'DiagnosticInfo'
					or diagnostic_level == vim.diagnostic.severity.WARN and 'DiagnosticWarn'
					or diagnostic_level == vim.diagnostic.severity.ERROR and 'DiagnosticError'
					or 'Normal'
				local filename_component = { filename, group = filename_hl }

				-- Modified icon
				local modified = vim.bo[props.buf].modified
				local modified_component = modified and { ' ● ', group = 'BufferCurrentMod' } or ''

				local ft_icon, ft_color = devicons.get_icon_color(filename)
				local icon_component = ft_icon and { ' ', ft_icon, ' ', guifg = ft_color } or ''

				return {
					modified_component,
					icon_component,
					' ',
					filename_component,
					' ',
					dirname_component,
					' ',
				}
			end,
		},
	},

	-- partition UI elements
	{
		'folke/edgy.nvim',
		event = 'VeryLazy',
		opts = {
			animate = { enabled = false },
			icons = {
				closed = '',
				open = '',
			},
			wo = { winbar = false },
			options = {
				left = { size = 35 },
				right = { size = 80 },
			},
			bottom = {
				{ ft = 'trouble', title = 'Trouble', size = { height = 0.3 } },
				{ ft = 'qf', title = 'QuickFix' },
				{
					ft = 'help',
					size = { height = 20 },
					-- only show help buffers
					filter = function(buf)
						return vim.bo[buf].buftype == 'help'
					end,
				},
				{
					ft = 'toggleterm',
					size = { height = 0.3 },
					-- exclude floating windows
					filter = function(_, win)
						return vim.api.nvim_win_get_config(win).relative == ''
					end,
				},
			},
			left = {
				{ ft = 'blink-tree' },
				{ ft = 'neo-tree' },
			},
			right = {
				{
					ft = 'toggleterm',
					-- exclude floating windows
					filter = function(_, win)
						return vim.api.nvim_win_get_config(win).relative == ''
					end,
				},
			},
		},
	},

	-- scrolling animation
	{
		'karb94/neoscroll.nvim',
	},

	-- show keymaps
	{ -- Useful plugin to show you pending keybinds.
		'folke/which-key.nvim',
		event = 'VimEnter',
		config = function(_, opts)
			require('which-key').setup(opts)

			-- 	-- Document existing key chains
			-- 	require('which-key').add({
			-- 		{ '<leader>c', group = '[C]ode' },
			-- 		{ '<leader>c_', hidden = true },
			-- 		{ '<leader>d', group = '[D]ocument' },
			-- 		{ '<leader>d_', hidden = true },
			-- 		{ '<leader>r', group = '[R]ename' },
			-- 		{ '<leader>r_', hidden = true },
			-- 		{ '<leader>s', group = '[S]earch' },
			-- 		{ '<leader>s_', hidden = true },
			-- 		{ '<leader>t', group = '[T]oggle' },
			-- 		{ '<leader>t_', hidden = true },
			-- 		{ '<leader>w', group = '[W]orkspace' },
			-- 		{ '<leader>w_', hidden = true },
			-- 		{
			-- 			mode = { 'v' },
			-- 			{ '<leader>h', group = 'Git [H]unk' },
			-- 			{ '<leader>h_', hidden = true },
			-- 		},
			-- 	})
		end,
	},

	-- live feedback for rename
	{
		'smjonas/inc-rename.nvim',
		keys = {
			{
				'<leader>cr',
				function()
					return ':IncRename ' .. vim.fn.expand('<cword>')
				end,
				expr = true,
				desc = 'Rename',
			},
		},
		config = function(_, opts)
			require('inc_rename').setup(opts)
		end,
	},

	-- preview definition in floating window
	{
		'rmagatti/goto-preview',
		event = 'VeryLazy',
		opts = {
			default_mappings = true,
			-- resizing_mappings = true,
			references = {
				telescope = require('telescope.themes').get_dropdown({ hide_preview = false }),
			},
		},
	},

	-- notifications
	{
		'j-hui/fidget.nvim',
		event = 'VeryLazy',
		opts = {
			notification = { window = { normal_hl = 'Normal' } },
			integration = {
				['nvim-tree'] = {
					enable = false,
				},
				['xcodebuild-nvim'] = {
					enable = false,
				},
			},
		},
	},

	{
		'lewis6991/satellite.nvim',
	},

	-- ui library
	{ 'MunifTanjim/nui.nvim' },

	-- TODO: remove the lowercase keywords since it's non-standard
	-- TODO: rewrite this myself
	{
		'folke/todo-comments.nvim',
		event = 'BufRead',
		keys = {
			{ '<leader>tq', '<cmd>TodoQuickFix<cr>', desc = 'Todos' },
			{ '<leader>td', '<cmd>Trouble todo<cr>', desc = 'Todos' },
		},
		opts = {
			keywords = {
				FIX = {
					icon = ' ',
					color = 'error',
					alt = { 'fix', 'FIXME', 'fixme', 'BUG', 'bug', 'FIXIT', 'fixit', 'ISSUE', 'issue' },
				},
				TODO = { icon = ' ', color = 'info', alt = { 'todo' } },
				HACK = { icon = ' ', color = 'warning', alt = { 'hack' } },
				WARN = { icon = ' ', color = 'warning', alt = { 'warn', 'WARNING', 'warning', 'XXX', 'xxx' } },
				PERF = {
					icon = ' ',
					alt = { 'perf', 'OPTIM', 'optim', 'PERFORMANCE', 'performance', 'OPTIMIZE', 'optimize' },
				},
				NOTE = { icon = ' ', color = 'hint', alt = { 'note', 'INFO', 'info' } },
				TEST = {
					icon = '⏲ ',
					color = 'test',
					alt = { 'test', 'TESTING', 'testing', 'PASSED', 'passed', 'FAILED', 'failed' },
				},
			},
		},
	},

	-- colorize hex, rgb, etc. codes
	{
		'catgoose/nvim-colorizer.lua',
		event = 'BufReadPre',
		opts = {
			user_default_options = {
				mode = 'virtualtext',
				names = false,
			},
		},
	},
}
