-- default detection doesnt work on new files
vim.filetype.add({
	extension = {
		tf = 'terraform',
	},
})

-- fix terraform and hcl comment string
-- https://neovim.discourse.group/t/commentstring-for-terraform-files-not-set/4066/2
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('FixTerraformCommentString', { clear = true }),
	callback = function(ev)
		vim.bo[ev.buf].commentstring = '# %s'
	end,
	pattern = { 'terraform', 'hcl' },
})

return {
	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable terraformls and tflint servers
			opts.servers.terraformls = {}
			opts.servers.tflint = {}

			-- tell efm to work with these filetypes
			vim.list_extend(opts.servers.efm.filetypes, {
				'terraform',
				'tf',
				'terraform-vars',
			})

			-- choose efm formatters and linters
			local terraform_fmt = require('efmls-configs.formatters.terraform_fmt')
			opts.servers.efm.settings.languages.terraform = { terraform_fmt }
			opts.servers.efm.settings.languages.tf = { terraform_fmt }
			opts.servers.efm.settings.languages['terraform-vars'] = { terraform_fmt }
		end,
	},
}
