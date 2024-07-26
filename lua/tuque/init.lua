-- load rest of config

-- load options and autocmds
require('tuque.opts')
require('tuque.autocmds')

-- load colorscheme
vim.cmd.colorscheme(nixCats('colorscheme'))

-- load lz.n
local lz = require('lz.n')

-- load categories
local categories = {
	'core',
	'ai',
	'blink',
	-- 'cmp',
	-- 'debug',
	-- 'format',
	'fugit',
	-- 'link',
	'lsp',
	-- 'statusline',
	-- 'bufferline',
	-- 'breadcrumb',
	-- 'winbar',
	-- 'extraUI',
	-- 'utils',
}

local spec = {}

for _, category in ipairs(categories) do
	if nixCats(category) then
		-- push category to spec
		table.insert(spec, require('tuque.' .. category))
		-- lz.load(require('tuque.' .. category))
	end
end

lz.load(spec)

-- load keymaps last
require('tuque.keys')
