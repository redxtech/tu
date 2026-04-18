-- enable elixir lsp server
vim.lsp.config('expert', { cmd = { 'expert' } })
vim.lsp.enable('expert')

-- TODO: switch to new elixir lsp: expert when it's in nixpkgs
