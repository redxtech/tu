local util = require('lspconfig/util')

local function root_pattern_excludes(opt)
	local root = opt.root
	local exclude = opt.exclude

	local function matches(path, pattern)
		return 0 < #vim.fn.glob(util.path.join(path, pattern))
	end

	return function(startpath)
		return util.search_ancestors(startpath, function(path)
			return matches(path, root) and not matches(path, exclude)
		end)
	end
end

return {
	-- linting/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			-- enable denols server
			opts.servers.denols = {
				root_dir = root_pattern_excludes({
					root = 'deno.jsonc?',
					exclude = 'package.json',
				}),
			}
		end,
	},

	{
		'stevearc/conform.nvim',
		name = 'conform-nvim',
		opts = function(_, opts)
			opts.formatters.deno_fmt = {
				condition = function(ctx)
					return vim.fs.find({ 'deno.json' }, { path = ctx.filename, upward = true })[1]
				end,
			}

			opts.formatters_by_ft.typescript = { 'deno_fmt' }
		end,
	},
}
