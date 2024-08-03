# tu

> a full-featured, self-contained, and fully nixed neovim configuration

## installation

you can actually run this configuration without installing it:

```sh
nix run github:redxtech/tu
```

or you can install it with nix:

```nix
{
    inputs.tu.url = "github:redxtech/tu";
    ...,
    system.environmentPackages = [
        tu.packages.${system}.default
    ];
}
```

## features

`tu` comes with a lot of features, as i'm a big fan of plugins. at some point, i
will make most of them optional, but for now, they are all enabled.

### core

- completion with `blink.cmp`
  - new completion engine to replace `nvim-cmp`. uses a custom fuzzy searcher.
    performance is improved through use of good algorithms in rust.
  - [`blink.nvim`](https://github.com/saghen/blink.nvim) comes with a couple
    other plugins:
    - `blink.chartoggle`: toggles `;` and `,` at end of line
    - `blink.indent`: fast version of indent-blankline
    - `blink.tree`: fast file tree, inspired by `neo-tree`
    - soon: `blink.select`: fast, simple, picker
- language servers
  - language servers for a large number of languages
  - lsp progress notififications (fidget)
  - rename, go to definition, and references, etc.
    - preview definition/references in floating window
  - better diagnostics ui, with trouble, diagflow, and lsp_lines
- linting and formatting
  - uses efm as a wrapper for many linters and formatters
- ui customization
  - `dracula.nvim`: my fork of the classic colorscheme
  - `bufferline.nvim`
  - `incline.nvim` (winbar)
  - `lualine.nvim`
  - `noice`
    - `nvim-notify`
  - `dashboard.nvim`
  - `rainbow-delimiters.nvim`
- git integration:
  - neogit
  - gitsigns
  - fugit2 (currenly disabled, behind the `fugit` category)
- code completion/predition with `supermaven-nvim`. it has been significantly
  better than `copilot`
- session & project management with `neovim-project` & `neovim-session-manager`
- a bunch of utility plugins
  - nix-reaver.nvim: my own plugin for updating `fetchFromGitHub`'s rev and hash
  - `nvim-navbuddy`: navigate through buffer, with `navic` assistance
  - `toggleterm.nvim`: toggleable terminal
  - `overseer.nvim`: task runner
  - `inc-rename.nvim`: visual rename
  - `lightbulb.nvim`: show icon when code actions are available
  - `nix-develop.nvim`: run `nix develop` without restarting neovim
  - `markview.nvim`: markdown preview
  - `moveline.nvim`: move blocks of text
  - `silicon.nvim`: screenshots of code
  - even more!

### languages

support for a lot of languages is included by default:

- lua
- nix
- rust
- web
  - javascript
  - typescript
  - jsx & tsx
  - json
  - html
  - css
  - json
  - graphql
  - vue
  - svelte
- shell
- python
- deno
- go
- c(pp)
- markdown
- docker
- yaml
- toml
- terraform
- protobuf

## provided binaries

### `tu`

the main `tu` binary, which has all the plugins enabled.

### `tu-dev`

a development version of `tu`, which has all the plugins installed, but reads
config from `~/.config/tu`, which allows you to change the lua configuration without
having to rebuild the entire package.

this is useful for when you're testing changes to the lua configuration, as you can
quickly test changes without waiting.

plugins are still installed with `lazy.nvim` if they aren't provided by nix, so you
can try out new plugins without having to add the plugin package to the nix config.

### `tu-profile`

this is the base `tu` binary, but with the `profile.nvim` plugin enabled. it will
start profiling as soon as you start neovim, and will stop profiling when you
press `<leader>q`.

## appimage

if you don't use nix, you can still use `tu` via the appimage!

it's quite large, but it has *everything* you need. language servers, binaries, everything.

you can download the latest appimage from the [releases page](https://github.com/redxtech/tu/releases).
