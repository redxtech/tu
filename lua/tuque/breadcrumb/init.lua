return {
	'barbecue-nvim',
	event = 'UIEnter',
	after = function(_)
		require('barbecue').setup({
			show_modified = true,
			no_name_title = '[no name]',
		})
	end,
}
