-- some config for neovim

-- set leader keys before loading plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- require opts and autocmds
require('tu.opts')
require('tu.autocmds')

-- load colorscheme
vim.cmd.colorscheme(nixCats('colorscheme'))

require('nixCatsUtils').setup({
	core = true,
	ai = true,
	blink = true,
	cmp = false,
	debug = false,
	format = true,
	fugit = true,
	git = true,
	langs = true,
	utils = true,
	profile = false,
	-- ui elements
	colorscheme = 'dracula',
	statusline = true,
	bufferline = true,
	uiElements = {
		barbecue = false,
		incline = true,
	},
})

vim.g.have_nerd_font = nixCats('have_nerd_font')

-- NOTE: nixCats: this is where we define some arguments for the lazy wrapper.
local pluginList = nil
local nixLazyPath = nil
if require('nixCatsUtils').isNixCats then
	local allPlugins = require('nixCats').pawsible.allPlugins
	-- it is called pluginList because we only need to pass in the names
	-- this list literally just tells lazy.nvim not to download the plugins in the list.
	pluginList = require('nixCatsUtils.lazyCat').mergePluginTables(allPlugins.start, allPlugins.opt)

	-- TODO:  add fallback to local projects dir for plugins with dev = true

	-- it wasnt detecting that these were already added
	-- because the names are slightly different from the url.
	-- when that happens, add them to the list, then also specify the new name in the lazySpec

	local wrongNames = {
		'any-jump.vim',
		'barbecue.nvim',
		'before.nvim',
		'better-escape.nvim',
		'blink.cmp',
		'blink.nvim',
		'bufferline.nvim',
		'diagflow.nvim',
		'diffview.nvim',
		'dracula.nvim',
		'efmls-configs-nvim',
		'fidget.nvim',
		'flash.nvim',
		'flatten.nvim',
		'gitsigns.nvim',
		'glow.nvim',
		'inc-rename.nvim',
		'incline.nvim',
		'lazy.nvim',
		'lazydev.nvim',
		'lsp_lines.nvim',
		'lualine.nvim',
		'mini.nvim',
		'moveline.nvim',
		'none-ls.nvim',
		'nui.nvim',
		'nvim-colorizer.lua',
		'oil.nvim',
		'tsc.nvim',
		'overseer.nvim',
		'rainbow-delimiters.nvim',
		'smart-open.nvim',
		'sort.nvim',
		'sqlite.lua',
		'telescope-repo.nvim',
		'tiny-devicons-auto-colors.nvim',
		'todo-comments.nvim',
		'toggleterm.nvim',
		'trouble.nvim',
		'yaml-companion.nvim',
		'which-key.nvim',
		'venv-selector.nvim',
	}

	for _, wrongName in ipairs(wrongNames) do
		pluginList[wrongName] = ''
	end

	-- HINT: to view the names of all plugins downloaded via nix, use the `:NixCats pawsible` command.

	-- we also want to pass in lazy.nvim's path
	-- so that the wrapper can add it to the runtime path
	-- as the normal lazy installation instructions dictate
	nixLazyPath = allPlugins.start[ [[lazy-nvim]] ]
end

-- NOTE: nixCats: You might want to move the lazy-lock.json file
local function getlockfilepath()
	if require('nixCatsUtils').isNixCats and type(require('nixCats').settings.unwrappedCfgPath) == 'string' then
		return require('nixCats').settings.unwrappedCfgPath .. '/lazy-lock.json'
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
	dev = {
		path = os.getenv('HOME') .. '/Code/nvim',
		patterns = { 'saghen', 'redxtech' },
		fallback = true,
	},
}

local categories = {
	'core',
	'ai',
	'blink',
	-- 'cmp',
	'debug',
	-- 'format',
	-- 'fugit',
	'git',
	'langs',
	'statusline',
	'bufferline',
	'utils',
	'profile',
}
local lazySpec = {}

for _, category in ipairs(categories) do
	-- if enabled, add category to spec
	if nixCats(category) then
		table.insert(lazySpec, {
			import = 'tu.' .. category,
		})
	end
end

local oldSpec = {
	-- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

	-- NOTE: nixCats: nix downloads it with a different file name.
	-- tell lazy about that.
	-- { 'numToStr/Comment.nvim', name = 'comment.nvim', opts = {} },

	-- { import = 'custom.plugins' },
}

require('nixCatsUtils.lazyCat').setup(pluginList, nixLazyPath, lazySpec, lazyOptions)

require('tu.keys')
