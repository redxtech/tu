local M = {}

-- easier to use map function
function M.map(mode, lhs, rhs, opts)
	opts = opts or { noremap = true }
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- helper to concat lz.n plugin specs
function M.concatSpecs(specs)
	local concatenated = {}
	for _, spec in ipairs(specs) do
		for _, value in ipairs(spec) do
			table.insert(concatenated, value)
		end
	end
	return concatenated
end

return M
