-- default detection doesnt work on new files
vim.filetype.add({
	extension = { tf = 'terraform' },
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

-- enable terraformls & tflint servers
vim.lsp.enable({ 'terraformls', 'tflint' })
