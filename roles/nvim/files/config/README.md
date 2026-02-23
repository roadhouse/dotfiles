# Neovim Config Quick Reference

## Leader e comportamento base

- `mapleader`: `Space`
- `;` abre command-line (`:`)
- `:` vira `;`
- `<Down>/<Up>/<Left>/<Right>` navegam entre splits
- `<A-j>` cria linha abaixo (normal mode)
- `<A-k>` cria linha acima (normal mode)
- `<Return>` no normal alterna fold (`zA`)
- `<Return>` no visual faz fold da selecao

## Atalhos gerais

- `<leader>l`: voltar para o buffer anterior (`:e#`)
- `<leader>a`: selecionar todo o buffer
- `cv`: copiar para clipboard do sistema (`"+y`)
- `cp`: colar do clipboard do sistema (`"+p`)

## Telescope

- `<leader>fh`: fuzzy no buffer atual
- `<leader>ff`: `git_files`
- `<leader>FF`: `find_files`
- `<leader>fg`: `live_grep`
- `<leader>fb`: buffers
- `<leader>fm`: simbolos do documento (LSP)
- `<leader>fr`: referencias (LSP)
- `<leader>fd`: definicoes (LSP)

## Diagnostics e Trouble

- `<leader>ft`: toggle diagnostics (Trouble)
- `<leader>xx`: diagnostics (Trouble)
- `<leader>xX`: diagnostics do buffer (Trouble)
- `<leader>xL`: location list (Trouble)
- `<leader>xQ`: quickfix list (Trouble)

## LSP (buffer-local via LspAttach)

- `gd`: go to definition
- `gD`: go to declaration
- `<leader>f`: format
- `<leader>e`: diagnostics na linha (float)
- `<leader>q`: manda diagnostics para loclist
- `[d`: diagnostic anterior
- `]d`: proximo diagnostic

Comando util:
- `:LspInstallAll`: instala todos os servers definidos no `mason-lspconfig.lua`

## Folding (nvim-origami)

- `h`: fecha fold quando aplicavel
- `l`: abre fold quando cursor esta em linha foldada
- `^`: fecha fold recursivo
- `$`: abre fold recursivo

## AI completion (Codeium)

- insert mode:
  - `<C-g>`: aceitar sugestao
  - `<M-]>`: proxima sugestao
  - `<M-[>`: sugestao anterior
  - `<C-x>`: limpar sugestao

## Comandos custom

- `:ReloadConfig`: recarrega a config Lua sem reiniciar o Neovim
- `:CmpToggle`: liga/desliga `nvim-cmp`
