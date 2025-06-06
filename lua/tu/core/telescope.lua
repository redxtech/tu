return {
	{
		'nvim-telescope/telescope-fzy-native.nvim',
		dependencies = {
			{
				'romgrk/fzy-lua-native',
				build = {
					'make',
					-- otherwise lazy.nvim will complain on checkout
					-- https://github.com/romgrk/fzy-lua-native/issues/23
					'git update-index --assume-unchanged static/libfzy-*.so',
				},
			},
			'nvim-telescope/telescope.nvim',
		},
		config = function()
			require('telescope').load_extension('fzy_native')
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
		},
		keys = {
			{ '<leader>.', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
			{ '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
			{ '<leader>/', '<cmd>Telescope live_grep<cr>', desc = 'Grep' },
			{ "<leader>'", '<cmd>Telescope registers<cr>', desc = 'Registers' },
			{ '<leader>y', '<cmd>Telescope lsp_document_symbols<cr>', desc = 'Goto Symbol' },
			{ '<leader>r', '<cmd>Telescope resume<cr>', desc = 'Resume last search' },
			{ '<leader><enter>', '<cmd>Telescope resume<cr>', desc = 'Resume last search' },
			{ '<leader>ds', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', desc = 'Goto Symbol (Workspace)' },

			-- find
			-- { '<leader>ff', '<cmd>Telescope git_files<cr>', desc = 'Find Git Files' },
			{ '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent' },
			-- { '<leader>fR', Util.telescope('oldfiles', { cwd = vim.loop.cwd() }), desc = 'Recent (cwd)' },
			{
				'<leader>fc',
				'<cmd>lua require("telescope.builtin").find_files({ cwd = "~/.config" })<cr>',
				desc = 'Find .config file',
			},
			{ '<leader>fg', "<cmd>lua require'telescope'.extensions.repo.list{}<cr>", desc = 'Git Repositories' },

			-- git
			{ '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'commits' },
			{ '<leader>gs', '<cmd>Telescope git_status<cr>', desc = 'status' },

			-- search
			{ '<leader>sa', '<cmd>Telescope autocommands<cr>', desc = 'Auto Commands' },
			{ '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Buffer' },
			{ '<leader>sc', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
			{ '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
			{ '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document diagnostics' },
			{ '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace diagnostics' },
			{ '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = 'Grep' },
			{ '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
			{ '<leader>sH', '<cmd>Telescope highlights<cr>', desc = 'Search Highlight Groups' },
			{ '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
			{ '<leader>sM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
			{ '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to Mark' },
			{ '<leader>so', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
			{ '<leader>cl', '<cmd>Telescope filetypes<cr>', desc = 'Pick Language' },
		},
		opts = function()
			-- local resolve = require('telescope.resolve')
			local actions = require('telescope.actions')
			return {
				defaults = {
					preview = {
						treesitter = {
							-- disable for languages where the semantic highlighting is good enough
							-- since it adds stutter on every buffer load
							disable = { 'javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'nix' },
						},
					},

					scroll_strategy = 'limit', -- don't rollover when scrolling
					sorting_strategy = 'ascending', -- show best result at the top
					layout_strategy = 'center',
					layout_config = {
						prompt_position = 'top',
						scroll_speed = 4,
						center = { width = 110 },
					},

					prompt_prefix = '  ',
					selection_caret = ' ',
					entry_prefix = ' ',
					border = true,
					borderchars = {
						prompt = { '─', '│', '─', '│', '┌', '┐', '│', '│' },
						results = { '─', '│', '─', '│', '├', '┤', '┘', '└' },
						preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
					},
					preview_title = false, -- disable
					results_title = false, -- disable

					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == '' then
								return win
							end
						end
						return 0
					end,
					file_ignore_patterns = { 'node_modules' },
					mappings = {
						i = {
							['<C-Left>'] = actions.cycle_history_prev,
							['<C-Right>'] = actions.cycle_history_next,
							['<C-Up>'] = actions.preview_scrolling_up,
							['<C-Down>'] = actions.preview_scrolling_down,
						},
						n = {
							['q'] = actions.close,
						},
					},
				},
			}
		end,
	},

	-- smarter file opening
	{
		'danielfalk/smart-open.nvim',
		branch = '0.2.x',
		dependencies = {
			{ 'kkharji/sqlite.lua' },
		},
		keys = {
			{
				'<leader><space>',
				function()
					require('telescope').extensions.smart_open.smart_open({ cwd_only = true })
				end,
				desc = 'Files',
			},
		},
		config = function()
			require('telescope').load_extension('smart_open')
		end,
	},

	-- zoxide integration
	{
		'jvgrootveld/telescope-zoxide',
		keys = {
			{ '<leader>fz', "<cmd>lua require('telescope').extensions.zoxide.list()<cr>", desc = 'Z' },
		},
		config = function()
			require('telescope').load_extension('zoxide')
		end,
	},

	-- fuzzy search over all repos on the system
	{
		'cljoly/telescope-repo.nvim',
		dependencies = {
			'nvim-telescope/telescope.nvim',
			{ 'nvim-lua/plenary.nvim' },
		},
		keys = {
			{ '<leader>fg', "<cmd>lua require'telescope'.extensions.repo.list{}<cr>", desc = 'Git Repositories' },
		},
		config = function()
			require('telescope').load_extension('repo')
		end,
	},
}
