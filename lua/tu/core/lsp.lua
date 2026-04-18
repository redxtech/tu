-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local function map(key, command, opts)
			local mode = opts.mode or 'n'
			opts.mode = nil
			opts.buffer = ev.buf
			vim.keymap.set(mode, key, command, opts)
		end

		map('<leader>cL', '<cmd>LspInfo<cr>', { desc = 'Lsp Info' })
		map('gd', function()
			require('telescope.builtin').lsp_definitions({ reuse_win = true })
		end, { desc = 'Goto Definition' })
		map('gr', '<cmd>Telescope lsp_references<cr>', { desc = 'References' })
		map('gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
		map('gI', function()
			require('telescope.builtin').lsp_implementations({ reuse_win = true })
		end, { desc = 'Goto Implementation' })
		map('gy', function()
			require('telescope.builtin').lsp_type_definitions({ reuse_win = true })
		end, { desc = 'Goto Type Definition' })
		map('K', vim.lsp.buf.hover, { desc = 'Hover' })
		map('gK', vim.lsp.buf.signature_help, { desc = 'Signature Help' })
		map('<c-k>', vim.lsp.buf.signature_help, { mode = 'i', desc = 'Signature Help' })
		map('<leader>cA', function()
			vim.lsp.buf.code_action({
				context = {
					only = {
						'source',
					},
					diagnostics = {},
				},
			})
		end, { desc = 'Source Action' })
	end,
})

return {
	{
		'neovim/nvim-lspconfig',
		event = 'BufRead',
		dependencies = {
			-- enable mason if nix wasnt involved
			{
				'mason-org/mason.nvim',
				enabled = require('nixCatsUtils').lazyAdd(true, false),
				priority = 1000,
				config = true,
			},
		},
		opts = { servers = {} },
		config = function(_, opts)
			for server, config in pairs(opts.servers) do
				vim.lsp.configure(server, config)
				vim.lsp.start(server)
			end
		end,
	},

	-- fast code actions picker
	{
		'Chaitanyabsprip/fastaction.nvim',
		keys = {
			{
				'<leader>a',
				function()
					require('fastaction').code_action()
				end,
				desc = 'Fast Action',
			},
		},
		---@type FastActionConfig
		opts = {},
	},

	{
		'rachartier/tiny-code-action.nvim',
		dependencies = {
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope.nvim' },
		},
		event = 'LspAttach',
		keys = {
			{
				'<leader>ca',
				function()
					require('tiny-code-action').code_action()
				end,
				desc = 'Code Action',
			},
		},
		opts = {},
	},

	-- emulates the LSP definition and references when unsupported
	{
		'pechorin/any-jump.vim',
		keys = {
			{ '<leader>j', '<cmd>AnyJump<cr>', desc = 'Grep References' },
		},
		init = function()
			vim.g.any_jump_disable_default_keybindings = 1
		end,
	},
}
