vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
	pattern = { '*/templates/*.yaml', '*/templates/*.tpl', '*.gotmpl', 'helmfile*.yaml' },
	callback = function()
		vim.opt_local.filetype = 'helm'
	end,
})

return {
	-- LSP and schemas for autocompletion
	{ 'towolf/vim-helm', ft = 'helm' },
	{
		'someone-stole-my-name/yaml-companion.nvim',
		dependencies = {
			{ 'neovim/nvim-lspconfig' },
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope.nvim' },
		},
		ft = 'yaml',
		keys = {
			{ '<leader>fy', '<cmd>Telescope yaml_schema<CR>', desc = 'YAML Schemas' },
		},
		config = function()
			local cfg = require('yaml-companion').setup()
			vim.lsp.config('yamlls', cfg)
			vim.lsp.config('helm_ls', {
				settings = {
					['helm-ls'] = {
						yamlls = cfg.settings['yamlls'],
					},
				},
			})
			vim.lsp.enable('yamlls')
			vim.lsp.enable('helm_ls')
			require('telescope').load_extension('yaml_schema')
		end,
	},
}
