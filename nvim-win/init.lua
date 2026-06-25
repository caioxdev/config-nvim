-- ============================================================
-- CORE
-- ============================================================
vim.loader.enable()
vim.g.mapleader = " "

vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 150
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8

-- ============================================================
-- DIAGNOSTICS
-- ============================================================
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  float = { border = "rounded" },
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})

-- ============================================================
-- FLOAT UI (moderno sem deprecated)
-- ============================================================
local function border(handler)
  return function(err, result, ctx, config)
    config = config or {}
    config.border = "rounded"
    return handler(err, result, ctx, config)
  end
end

vim.lsp.handlers["textDocument/hover"] = border(vim.lsp.handlers.hover)
vim.lsp.handlers["textDocument/signatureHelp"] = border(vim.lsp.handlers.signature_help)

-- ============================================================
-- LAZY
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
-- PLUGINS (LAZY BY DESIGN)
-- ============================================================
require("lazy").setup({

  { "folke/tokyonight.nvim" },
  { "nvim-tree/nvim-web-devicons" },
  { "folke/which-key.nvim", opts = {}, event = "VeryLazy" },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Oil",
    opts = { view_options = { show_hidden = true } },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  { "lewis6991/gitsigns.nvim", event = "BufReadPost", opts = {} },

  -- MASON
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
  },

  -- CMP
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
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
        "lua","vim","vimdoc",
        "js","ts","html","css","json",
        "python","go","rust","c","cpp","php",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
})

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

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- ============================================================
-- CMP
-- ============================================================
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
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

-- autopairs
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
    "clangd",
  },
})

-- ============================================================
-- LSP CAPABILITIES
-- ============================================================
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ============================================================
-- FORMAT BY LANGUAGE (IMPORTANTE)
-- ============================================================
local format_map = {
  lua = function()
    return { "stylua" }
  end,
  python = function()
    return { "black" }
  end,
  javascript = function()
    return { "prettier" }
  end,
  typescript = function()
    return { "prettier" }
  end,
}

local function format_on_save(bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end,
  })
end

-- ============================================================
-- LSP PER FILETYPE (ESSENCIAL)
-- ============================================================
local function setup_lsp(name, config)
  vim.lsp.config(name, {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      local opts = { buffer = bufnr }

      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

      format_on_save(bufnr)
    end,
  })

  vim.lsp.enable(name)
end

setup_lsp("lua_ls")
setup_lsp("ts_ls")
setup_lsp("html")
setup_lsp("cssls")
setup_lsp("jsonls")
setup_lsp("pyright")
setup_lsp("gopls")
setup_lsp("rust_analyzer")
setup_lsp("clangd")

-- ============================================================
-- FINAL
-- ============================================================
print("Neovim ARCH READY (optimized + lazy + modular LSP)")
