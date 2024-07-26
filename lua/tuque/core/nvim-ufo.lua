return {
	'nvim-ufo',
	enabled = false,
	after = function(_)
		require('ufo').setup({
			-- dont fold by default
			close_fold_kinds_for_ft = { default = {} },
			open_fold_hl_timeout = 150,
			enable_get_fold_virt_text = false,
			preview = {
				win_config = {
					border = 'rounded',
					winblend = 12,
					winhighlight = 'Normal:Normal',
					maxheight = 20,
				},
			},
			-- use treesitter for finding folds
			provider_selector = function(_, _, _)
				return { 'treesitter', 'indent' }
			end,
			-- Adding number suffix of folded lines instead of the default ellipsis
			-- https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#customize-fold-text
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (' 󰁂 %d '):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, 'MoreMsg' })
				return newVirtText
			end,
		})
	end,
}
