-- some config for neovim

-- set leader keys before loading plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- require opts and autocmds
require('tu.opts')
require('tu.autocmds')

-- NOTE: this just gives nixCats global command a default value
-- so that it doesnt throw an error if you didnt install via nix.
-- usage of both this setup and the nixCats command is optional,
-- but it is very useful for passing info from nix to lua so you will likely use it at least once.
require('nixCatsUtils').setup({
	core = true,
	ai = true,
	blink = true,
	cmp = false,
	debug = false,
	fugit = true,
	git = true,
	langs = true,
	utils = true,
	profile = false,
	-- ui elements
	colorscheme = 'dracula',
	statusline = true,
	bufferline = true,
})

-- load colorscheme
vim.cmd.colorscheme(nixCats('colorscheme'))

vim.g.have_nerd_font = nixCats('have_nerd_font')

-- NOTE: You might want to move the lazy-lock.json file
local function getlockfilepath()
	if require('nixCatsUtils').isNixCats and type(nixCats.settings.unwrappedCfgPath) == 'string' then
		return nixCats.settings.unwrappedCfgPath .. '/lazy-lock.json'
	else
		return vim.fn.stdpath('config') .. '/lazy-lock.json'
	end
end

local lazyOptions = {
	lockfile = getlockfilepath(),
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = '⌘',
			config = '🛠',
			event = '📅',
			ft = '📂',
			init = '⚙',
			keys = '🗝',
			plugin = '🔌',
			runtime = '💻',
			require = '🌙',
			source = '📄',
			start = '🚀',
			task = '📌',
			lazy = '💤 ',
		},
	},
	install = {
		colorscheme = { nixCats('colorscheme') },
	},
	change_detection = {
		enabled = false,
	},
	-- dev = {
	-- 	path = os.getenv('HOME') .. '/Code/nvim',
	-- 	-- patterns = { 'saghen', 'redxtech' },
	-- 	fallback = true,
	-- },
}

local lazySpec = {}

for category, enabled in pairs(nixCats.cats) do
	-- if enabled, add category to spec
	-- first filter out the nixCats_ meta-categories
	if type(enabled) == 'boolean' and category:find('nixCats_') ~= 1 and enabled then
		table.insert(lazySpec, {
			import = 'tu.' .. category,
		})
	end
end

-- NOTE: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require('nixCatsUtils.lazyCat').setup(nixCats.pawsible({ 'allPlugins', 'start', 'lazy.nvim' }), lazySpec, lazyOptions)

require('tu.keys')
