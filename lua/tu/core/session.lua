return {
	-- project and session management
	{
		'coffebar/neovim-project',
		lazy = vim.fn.getcwd() == os.getenv('HOME'),
		dependencies = {
			'Shatur/neovim-session-manager',
			'nvim-telescope/telescope.nvim',
			{ 'nvim-lua/plenary.nvim' },
			-- to avoid calling before loaded
			'nvim-treesitter/nvim-treesitter',
			'kevinhwang91/nvim-ufo',
			'saghen/blink.nvim',
			'neovim/nvim-lspconfig',
		},
		cmd = { 'NeovimProjectLoad', 'NeovimProjectLoadDashboard' },
		keys = {
			{ '<leader>fp', '<cmd>Telescope neovim-project discover<cr>', desc = 'Projects' },
			{ '<leader>fh', '<cmd>Telescope neovim-project history<cr>', desc = 'Sessions' },
		},
		init = function()
			-- todo: open blink tree if it was previously open
			local sessions_group = vim.api.nvim_create_augroup('TuqueSessions', {})
			-- open blink tree (disabled in dev environment)
			if os.getenv('NVIM_DEV') == nil then
				vim.api.nvim_create_autocmd({ 'User' }, {
					pattern = 'SessionLoadPost',
					group = sessions_group,
					command = 'BlinkTree open',
				})
			end

			-- The dashboard returns the full path of the project but the
			-- NeovimProjectLoad command expects the path to be the same as the one in the projects list
			-- so we need to replace the home directory with ~
			vim.api.nvim_create_user_command('NeovimProjectLoadDashboard', function(args)
				local cwd = args.args
				local home = os.getenv('HOME')
				if home == nil then
					return vim.cmd('NeovimProjectLoad ' .. cwd)
				end

				local project = cwd:gsub(home, '~')
				vim.cmd('NeovimProjectLoad ' .. project)
			end, { nargs = 1 })
			vim.opt.sessionoptions = { 'buffers', 'curdir', 'folds', 'globals', 'tabpages', 'winsize' }
		end,
		opts = {
			last_session_on_startup = false,
			session_manager_opts = {
				autosave_ignore_buftypes = { 'nowrite' },
				autosave_ignore_filetypes = { 'blink-tree' },
			},
			-- NOTE: these are my personal project locations
			projects = {
				-- projects
				'~/Code/*',
				'~/Code/nvim/*',
				'~/Software/*',
				'~/Work/*/*',

				-- dotfiles
				-- '~/.config/*',
			},
		},
	},
}
