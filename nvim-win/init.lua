vim.loader.enable()
vim.g.mapleader = " "

-- ============================================================
-- LAZY BOOTSTRAP
-- ============================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- PLUGINS
-- ============================================================

require("lazy").setup({
  -- THEME
  { "folke/tokyonight.nvim" },

  -- PRODUCTIVITY
  { "nvim-tree/nvim-web-devicons" },
  { "folke/which-key.nvim", opts = {} },

  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { view_options = { show_hidden = true } },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  { "lewis6991/gitsigns.nvim", opts = {} },

  -- LSP + MASON
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

  -- AUTOCOMPLETE
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- TREESITTER (CORRIGIDO)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "html",
        "css",
        "json",
        "python",
        "go",
        "rust",
        "c",
        "cpp",
        "php",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
})

-- ============================================================
-- OPTIONS
-- ============================================================

vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.shell = "pwsh"
vim.o.termguicolors = true

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true

vim.o.scrolloff = 8
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250

vim.o.autochdir = false

-- ============================================================
-- THEME
-- ============================================================

vim.cmd.colorscheme("tokyonight-night")

-- ============================================================
-- KEYMAPS BASE
-- ============================================================

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil" })

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- terminal
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("botright 12split")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end)

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- reload config
vim.keymap.set("n", "<leader>r", "<cmd>source $MYVIMRC<CR>")

-- ============================================================
-- AUTOPAIRS
-- ============================================================

require("nvim-autopairs").setup()

-- ============================================================
-- MASON
-- ============================================================

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",
    "html",
    "cssls",
    "jsonls",
    "pyright",
    "gopls",
    "rust_analyzer",
    "intelephense",
    "clangd",
  },
})

-- ============================================================
-- LSP (NEOVIM 0.11+ CORRIGIDO)
-- ============================================================

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.lsp.enable({
  "lua_ls",
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  "pyright",
  "gopls",
  "rust_analyzer",
  "intelephense",
  "clangd",
})

-- ============================================================
-- CMP
-- ============================================================

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),

  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- autopairs + cmp
require("nvim-autopairs").setup()
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- ============================================================
-- FINAL
-- ============================================================

print("Neovim loaded successfully")