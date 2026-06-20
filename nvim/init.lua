vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<BS>", "<C-^>")

vim.keymap.set("n", "<leader>sd", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>nd", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>pd", vim.diagnostic.goto_prev)

vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end)

vim.keymap.set({ "v", "x" }, "<leader>ae", "<cmd>:'<,'>! column -t -s '=' -o '='<CR>")
vim.keymap.set({ "n", "v" }, "<leader>jj", "Vyp")
vim.keymap.set({ "n", "v" }, "<leader>kk", "VyP")

vim.keymap.set("n", "<leader>tr", ":term<CR>i")
vim.keymap.set("n", "<leader>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("L")
    vim.api.nvim_win_set_width(0, 100)
end)
vim.keymap.set("t", "<C-x>", "<C-\\><C-n>")

vim.api.nvim_set_keymap('t', '<C-l><C-l>', [[<C-\><C-N>:lua ClearTerm(0)<CR>]], {})
vim.api.nvim_set_keymap('t', '<C-l><C-l><C-l>', [[<C-\><C-N>:lua ClearTerm(1)<CR>]], {})

function ClearTerm(reset)
    vim.opt_local.scrollback = 1
    vim.api.nvim_command("startinsert")
    if reset == 1 then
        vim.api.nvim_feedkeys("reset", 't', false)
    else
        vim.api.nvim_feedkeys("clear", 't', false)
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<cr>', true, false, true), 't', true)
    vim.opt_local.scrollback = 10000
end

vim.opt.guicursor = "a:ver25"
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 0
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 32
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.virtualedit = "all"
vim.g.moonflyTransparent = true

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.h",
    command = "set filetype=c",
})

local function gh(x)
    return "https://github.com/" .. x
end

-- PLUGINS
vim.pack.add({
    { src = gh("echasnovski/mini.icons") },
    { src = gh("stevearc/oil.nvim") },
})
require("oil").setup({
    view_options = { show_hidden = true },
})

vim.pack.add({ gh("CarraraSoftware/href.nvim") })
require("href").setup()

vim.pack.add({ { src = gh("bluz71/vim-moonfly-colors"), name = "moonfly" } })
vim.g.moonflyItalics = false
vim.cmd.colorscheme("moonfly")

vim.pack.add({ gh("laytan/cloak.nvim") })
require('cloak').setup({
    enabled = true,
    cloak_character = '*',
    highlight_group = 'Comment',
    cloak_length = nil,
    try_all_patterns = true,
    cloak_telescope = true,
    cloak_on_leave = false,
    patterns = {
        { file_pattern = '*.env*', cloak_pattern = '=.+', replace = nil },
    },
})

vim.pack.add({ gh("nvim-lualine/lualine.nvim") })
require('lualine').setup({
    options = { theme = 'codedark' },
})

vim.pack.add({ gh("brenoprata10/nvim-highlight-colors") })
require("nvim-highlight-colors").setup({
    render = "virtual",
    virtual_symbol = "■",
    virtual_symbol_prefix = "",
    virtual_symbol_suffix = "",
    virtual_symbol_position = "eol",
    enable_hex = true,
    enable_short_hex = true,
    enable_rgb = true,
    enable_hsl = true,
    enable_hsl_without_function = true,
    enable_var_usage = true,
    enable_named_colors = true,
    enable_tailwind = true,
})

vim.pack.add({ gh('MeanderingProgrammer/render-markdown.nvim') })

-- TREESITTER
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")
vim.pack.add({ gh("nvim-treesitter/nvim-treesitter") })
local treesitter = require("nvim-treesitter")
treesitter.setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
    highlight = { enable = true },
    indent = { enable = true },
})
treesitter.install({
    "lua", "html", "json", "xml", "sql",
    "javascript", "typescript", "vue", "scss", "c", "cpp",
})
vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if vim.list_contains(treesitter.get_available(), lang) then
            if not vim.list_contains(treesitter.get_installed(), lang) then
                treesitter.install(lang):wait()
            end
            vim.treesitter.start(args.buf)
        end
    end,
})

-- TELESCOPE
local install_telescope_fzf = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
        vim.system({ "make" }, { cwd = ev.data.path }):wait()
    end
end
vim.api.nvim_create_autocmd("PackChanged", { callback = install_telescope_fzf })
vim.pack.add({ gh("nvim-lua/plenary.nvim") })
vim.pack.add({ gh("nvim-telescope/telescope-fzf-native.nvim") })
vim.pack.add({ gh("nvim-telescope/telescope.nvim") })
vim.pack.add({ gh("nvim-telescope/telescope-ui-select.nvim") })
local telescope = require("telescope")
telescope.setup({
    extensions = {
        fzf = {},
        ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
    },
    defaults = {
        file_ignore_patterns = { "node_modules", "__pycache__" },
    },
})
telescope.load_extension("fzf")
telescope.load_extension("ui-select")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<C-b>", builtin.buffers, {})
vim.keymap.set("n", "<C-h>", builtin.command_history, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>mp", builtin.man_pages, {})

-- NULL-LS
vim.pack.add({ gh("nvimtools/none-ls.nvim") })
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylelint,
    },
})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})

-- AUTOCOMPLETE
vim.pack.add({
    gh("hrsh7th/cmp-nvim-lsp"),
    gh("saadparwaiz1/cmp_luasnip"),
    gh("rafamadriz/friendly-snippets"),
    gh("L3MON4D3/LuaSnip"),
    gh("hrsh7th/nvim-cmp"),
})
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                if luasnip.expandable() then luasnip.expand()
                else cmp.confirm({ select = true }) end
            else fallback() end
        end),
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.locally_jumpable(1) then luasnip.jump(1)
            else fallback() end
        end, { "i", "s" }),
        ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.locally_jumpable(-1) then luasnip.jump(-1)
            else fallback() end
        end, { "i", "s" }),
    }),
    formatting = { format = require("nvim-highlight-colors").format },
    sources = cmp.config.sources(
        { { name = "nvim_lsp" }, { name = "luasnip" } },
        { { name = "buffer" } }
    ),
})

-- LSP
vim.pack.add({
    gh("williamboman/mason.nvim"),
    gh("williamboman/mason-lspconfig.nvim"),
    gh("neovim/nvim-lspconfig"),
})
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "html",
        "jsonls",
        "cssls",
        "tailwindcss",
        "ts_ls",
        "stylelint_lsp",
        "vue_ls",
        "clangd",
    },
})
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.config.lua_ls = {
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
}

vim.lsp.config.clangd = {
    cmd = { 'clangd', '--clang-tidy', '--background-index', '--offset-encoding=utf-8' },
    root_markers = { '.clangd', 'compile_commands.json' },
    filetypes = { 'c', 'cpp' },
}

vim.lsp.config.vue_ls = {
    filetypes = { 'vue' },
}

vim.lsp.config.stylelint_lsp = {
    filetypes = { 'css', 'scss', 'sass', 'less' },
}

vim.diagnostic.config({ underline = false })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

-- AUTOPAIRS
vim.pack.add({ gh("windwp/nvim-autopairs") })
require("nvim-autopairs").setup({ pairs_map = { ["<"] = ">" } })
vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "TextChangedI" }, { callback = function() if vim.bo.modified and vim.bo.buftype == "" then vim.cmd("silent write") end end })