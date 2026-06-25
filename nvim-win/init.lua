
-- ============================================================
-- CORE
-- ============================================================
vim.loader.enable()
vim.g.mapleader = " "

-- clipboard Windows
vim.opt.clipboard = "unnamedplus"

-- shell Windows safe
if vim.fn.executable("pwsh") == 1 then
  vim.o.shell = "pwsh"
elseif vim.fn.executable("powershell") == 1 then
  vim.o.shell = "powershell"
end

-- ============================================================
-- LAZY BOOTSTRAP
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- PLUGINS
-- ============================================================
require("lazy").setup({

  -- THEME
  { "folke/tokyonight.nvim" },

  -- UI
  { "nvim-tree/nvim-web-devicons" },
  { "folke/which-key.nvim", opts = {} },

  -- AUTOPAIRS
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  -- FILE EXPLORER
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { view_options = { show_hidden = true } },
  },

  -- TELESCOPE
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- GIT
  { "lewis6991/gitsigns.nvim", opts = {} },

  -- MASON
  { "williamboman/mason.nvim", opts = {} },
  { "williamboman/mason-lspconfig.nvim" },

  -- LSP CONFIG (registry)
  { "neovim/nvim-lspconfig" },

  -- CMP
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

  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
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
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
})

-- ============================================================
-- OPTIONS
-- ============================================================
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = "a"
vim.o.termguicolors = true
vim.o.signcolumn = "yes"

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 200

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.scrolloff = 8

-- ============================================================
-- THEME
-- ============================================================
vim.cmd.colorscheme("tokyonight-night")

-- ============================================================
-- KEYMAPS
-- ============================================================

local telescope = require("telescope.builtin")

vim.keymap.set("n", "-", "<cmd>Oil<cr>")

vim.keymap.set("n", "<leader>ff", telescope.find_files)
vim.keymap.set("n", "<leader>fg", telescope.live_grep)
vim.keymap.set("n", "<leader>fb", telescope.buffers)

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- clipboard
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y')
vim.keymap.set("v", "<C-v>", '"+p')
vim.keymap.set("i", "<C-v>", "<C-r>+")

-- terminal
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("botright 12split")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- ============================================================
-- AUTOPAIRS + CMP
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

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- ============================================================
-- MASON + LSP (NOVO NVIM 0.12)
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

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- NOVO SISTEMA LSP (SEM lspconfig.setup)
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
-- FINAL
-- ============================================================
print("Neovim OK")
