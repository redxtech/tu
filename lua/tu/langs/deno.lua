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
					root = 'deno.json?',
					exclude = 'package.json',
				}),
			}

			-- tell efm to work with these filetypes
			table.insert(opts.servers.efm.filetypes, 'typescript')

			-- choose efm formatters and linters
			opts.servers.efm.settings.languages.typescript = {
				require('efmls-configs.formatters.deno_fmt'),
			}
		end,
	},
}
