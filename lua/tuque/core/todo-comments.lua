return {
	'todo-comments-nvim',
	event = 'BufReadPost',
	after = function(_)
		require('todo-comments').setup({
			keywords = {
				FIX = {
					icon = ' ',
					color = 'error',
					alt = { 'fix', 'FIXME', 'fixme', 'BUG', 'bug', 'FIXIT', 'fixit', 'ISSUE', 'issue' },
				},
				TODO = { icon = ' ', color = 'info', alt = { 'todo' } },
				HACK = { icon = ' ', color = 'warning', alt = { 'hack' } },
				WARN = { icon = ' ', color = 'warning', alt = { 'warn', 'WARNING', 'warning', 'XXX', 'xxx' } },
				PERF = {
					icon = ' ',
					alt = { 'perf', 'OPTIM', 'optim', 'PERFORMANCE', 'performance', 'OPTIMIZE', 'optimize' },
				},
				NOTE = { icon = ' ', color = 'hint', alt = { 'note', 'INFO', 'info' } },
				TEST = {
					icon = '⏲ ',
					color = 'test',
					alt = { 'test', 'TESTING', 'testing', 'PASSED', 'passed', 'FAILED', 'failed' },
				},
			},
		})
	end,
}
