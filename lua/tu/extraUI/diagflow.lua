return {
	'diagflow-nvim',
	event = 'LspAttach',
	after = function(_)
		require('diagflow').setup({})
	end,
}
