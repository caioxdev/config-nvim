# config-nvim

Configuração pessoal de ambiente de desenvolvimento no WSL2 + Neovim.

> Base do `init.lua` adaptada de [CarraraSoftware/init.lua](https://github.com/CarraraSoftware) com modificações pessoais.

## Estrutura

```
config-nvim/
├── nvim/
│   └── init.lua
└── README.md
```

---

## Requisitos

- Windows 10 (build 19041+) ou Windows 11
- WSL2 com Ubuntu 24.04
- Neovim >= 0.12.0
- Node.js (via fnm)
- Git

---

## Instalação do ambiente

### 1. WSL2

No PowerShell como administrador:

```powershell
wsl --install
```

Reinicia o PC. Na primeira abertura do Ubuntu, cria usuário e senha.

Verifica a versão:

```powershell
wsl -l -v
```

A coluna `VERSION` deve mostrar `2`.

---

### 2. Dependências base

```bash
sudo apt update
sudo apt install build-essential gdb unzip -y
```

---

### 3. Node.js via fnm

```bash
curl -fsSL https://fnm.vercel.app/install | bash
source ~/.bashrc
fnm install --lts
```

Cria symlinks globais (necessário para o Mason encontrar o Node):

```bash
sudo mkdir -p /usr/local/bin
sudo ln -sf $(which node) /usr/local/bin/node
sudo ln -sf $(which npm) /usr/local/bin/npm
```

---

### 4. Neovim 0.12+

```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim -y
```

Instala o tree-sitter-cli (necessário para os parsers):

```bash
npm install -g tree-sitter-cli
```

---

### 5. Clonar e aplicar os dotfiles

```bash
git clone https://github.com/caioxdev/config-nvim.git ~/config-nvim
mkdir -p ~/.config/nvim
ln -s ~/config-nvim/nvim/init.lua ~/.config/nvim/init.lua
```

Abre o Neovim:

```bash
nvim
```

Os plugins são baixados automaticamente na primeira abertura. Aguarda terminar.

---

## O que está configurado

### Linguagens suportadas

| Linguagem | LSP | Treesitter |
|-----------|-----|------------|
| C / C++ | clangd | ✓ |
| JavaScript / TypeScript | ts_ls | ✓ |
| HTML | html | ✓ |
| CSS / SCSS / Sass | cssls, stylelint_lsp | ✓ |
| Vue | vue_ls | ✓ |
| JSON | jsonls | ✓ |
| Lua | lua_ls | ✓ |
| SQL / XML | — | ✓ |

### Plugins

| Plugin | Função |
|--------|--------|
| [oil.nvim](https://github.com/stevearc/oil.nvim) | Navegador de arquivos |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Busca de arquivos e texto |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocomplete |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | Snippets |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Gerenciador de LSPs |
| [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) | Formatação (prettier, stylelint) |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Barra de status |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Fecha `()`, `{}`, `[]`, `<>` |
| [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) | Preview de cores inline |
| [cloak.nvim](https://github.com/laytan/cloak.nvim) | Oculta valores em `.env` |
| [vim-moonfly-colors](https://github.com/bluz71/vim-moonfly-colors) | Tema |

---

## Keymaps principais

`<leader>` = `Space`

| Keymap | Ação |
|--------|------|
| `-` ou `<leader>pv` | Abre Oil (navegador de arquivos) |
| `<C-p>` | Telescope: busca arquivos |
| `<C-b>` | Telescope: lista buffers |
| `<leader>fg` | Telescope: busca por texto |
| `<leader>gf` | Formata o arquivo (LSP) |
| `<leader>ca` | Code actions |
| `gd` | Vai para definição |
| `gD` | Vai para declaração |
| `K` | Documentação do símbolo |
| `<leader>nd` / `<leader>pd` | Próximo / anterior diagnóstico |
| `<leader>sd` | Abre diagnóstico flutuante |
| `<leader>st` | Abre terminal lateral |
| `<C-x>` | Sai do modo terminal |
| `<leader>s` | Find and replace palavra atual |
| `<leader>y` | Copia para clipboard do sistema |
| `<leader>jj` | Duplica linha abaixo |
| `<leader>kk` | Duplica linha acima |

---

## Live Server (HTML)

Para auto-reload no browser ao editar HTML/CSS:

```bash
npm install -g live-server
```

Na pasta do projeto:

```bash
live-server
```

Acessa `http://127.0.0.1:8080` no browser.

---

## Créditos

- Base do `init.lua`: [CarraraSoftware](https://github.com/CarraraSoftware)
- Inspiração nos keymaps: [ThePrimeagen](https://github.com/ThePrimeagen/init.lua)