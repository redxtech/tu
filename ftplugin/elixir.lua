-- enable elixir lsp server
vim.lsp.config('lexical', { cmd = { 'lexical' } })
vim.lsp.enable('lexical')

-- TODO: switch to new elixir lsp: expert when it's in nixpkgs
