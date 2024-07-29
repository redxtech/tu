return {
	{
		'akinsho/bufferline.nvim',
		name = 'bufferline-nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function(_, opts)
			require('bufferline').setup(opts)
		end,
	},
}
