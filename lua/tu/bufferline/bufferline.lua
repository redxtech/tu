return {
	{
		'akinsho/bufferline.nvim',
		name = 'bufferline-nvim',
		dependencies = 'nvim-tree/nvim-web-devicons',
		opts = function()
			return {
				options = {
					themable = true,
					indicator = {
						style = 'underline',
					},
					separator_style = 'slant',
					show_tab_indicators = true,

					numbers = function(opts)
						return opts.raise(opts.ordinal)
					end,

					close_command = function(bufnr)
						require('mini.bufremove').delete(bufnr)
					end,
					middle_click_command = function(bufnr)
						require('mini.bufremove').delete(bufnr, true)
					end,
					right_mouse_command = 'BufferLineTogglePin',

					diagnostics = 'nvim_lsp',
					offsets = {
						{
							filetype = 'blink-tree',
							text = 'Blink Tree',
							text_align = 'left',
							separator = true,
						},
						{
							filetype = 'neo-tree',
							text = 'Neo Tree',
							text_align = 'left',
							separator = true,
						},
					},
					groups = {
						items = {
							require('bufferline.groups').builtin.pinned,
						},
					},
				},
			}
		end,
		config = function(_, opts)
			require('bufferline').setup(opts)
		end,
	},
}
