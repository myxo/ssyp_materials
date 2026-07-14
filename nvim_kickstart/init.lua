--[[

  Kickstart Neovim config

  WHERE TO PUT THIS FILE:
    Linux/macOS:  ~/.config/nvim/init.lua

  REQUIREMENTS:
    - Neovim >= 0.12 (uses the built-in `vim.pack` plugin manager
    - git (used by vim.pack to download plugins).
    - clangd installed and on your $PATH, for C/C++ language support.
        macOS:   brew install llvm          (or) xcode-select --install
        Ubuntu:  sudo apt install clangd
        Arch:    sudo pacman -S clang
    - (optional) ripgrep, for Telescope live_grep / grep_string to work.
        macOS:   brew install ripgrep
        Ubuntu:  sudo apt install ripgrep

  On first launch, Neovim will automatically download the plugins below
  (you may see a confirmation prompt — press :w to accept). This only
  happens once.

--]]

-- =====================================================================
-- 1. BASIC / COMMON SETTINGS
-- =====================================================================

-- Use space as the leader key (must be set before any <leader> mappings)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

-- Indentation: 4 spaces, no tabs
opt.tabstop = 4        -- number of spaces a <Tab> counts for
opt.shiftwidth = 4     -- number of spaces used for each indent step
opt.softtabstop = 4    -- number of spaces a <Tab> counts for while editing
opt.expandtab = true   -- convert tabs to spaces
opt.smartindent = true -- automatic indenting for new lines
opt.autoindent = true

-- UI
opt.number = true         -- show line numbers
opt.relativenumber = true -- ...and relative numbers (great for jumping)
opt.cursorline = true     -- highlight current line
opt.signcolumn = 'yes'    -- always show sign column (avoids text shifting)
opt.termguicolors = true  -- enable 24-bit colors
opt.scrolloff = 8         -- keep 8 lines visible above/below cursor
opt.wrap = false          -- don't soft-wrap long lines

-- Search
opt.ignorecase = true -- case-insensitive search...
opt.smartcase = true  -- ...unless the query has capital letters
opt.incsearch = true
opt.hlsearch = true

-- Splits
opt.splitright = true -- vertical splits open to the right
opt.splitbelow = true -- horizontal splits open below

-- Files
opt.swapfile = false
opt.undofile = true  -- persistent undo history across sessions
opt.updatetime = 250 -- faster CursorHold / diagnostics popup

-- Show some invisible characters
opt.list = true
opt.listchars = { tab = '» ', trailing = '·', nbsp = '␣' }

-- Quality-of-life keymaps
local map = vim.keymap.set
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- =====================================================================
-- 2. PLUGINS
-- =====================================================================

vim.pack.add({
  -- Telescope: fuzzy finder for files, text, buffers, etc.
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- Telescope dependency
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },

  -- Nicer syntax highlighting (optional but very common)
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },
})

-- ---------------------------------------------------------------------
-- Treesitter: better, more accurate syntax highlighting
-- ---------------------------------------------------------------------
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc' },
  auto_install = true, -- automatically install parser for new filetypes
  highlight = { enable = true },
  indent = { enable = true },
})

-- ---------------------------------------------------------------------
-- Telescope: see/search files in the current folder and below
-- ---------------------------------------------------------------------
local telescope = require('telescope')
telescope.setup({
  defaults = {
    file_ignore_patterns = { '%.git/', 'node_modules/', 'build/' },
  },
})

local tb = require('telescope.builtin')
map('n', '<leader>ff', tb.find_files, { desc = 'Telescope: find files' })
map('n', '<leader>fg', tb.live_grep, { desc = 'Telescope: live grep (needs ripgrep)' })
map('n', '<leader>fb', tb.buffers, { desc = 'Telescope: list open buffers' })
map('n', '<leader>fh', tb.help_tags, { desc = 'Telescope: help tags' })
map('n', '<leader>fw', tb.grep_string, { desc = 'Telescope: grep word under cursor' })
map('n', '<leader>fo', tb.oldfiles, { desc = 'Telescope: recently opened files' })

-- =====================================================================
-- 3. LSP: clangd (C / C++ / Objective-C)
-- =====================================================================

-- Define the clangd server config using Neovim's native LSP API
-- (no nvim-lspconfig plugin required).
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = {
    '.clangd',
    '.clang-tidy',
    '.clang-format',
    'compile_commands.json',
    'compile_flags.txt',
    '.git',
  },
})

-- Turn it on: Neovim will auto-attach clangd whenever you open a
-- matching filetype inside a project containing one of the root markers.
vim.lsp.enable('clangd')

-- Nice-to-have: rounded borders on hover/signature popups
vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  severity_sort = true,
  float = { border = 'rounded' },
})

-- LSP keymaps: only set them in buffers that actually have an LSP client attached
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Go to definition' }))
    map('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Go to declaration' }))
    map('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Go to references' }))
    map('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Go to implementation' }))
    map('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover documentation' }))
    map('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename symbol' }))
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code action' }))
    map('n', '<leader>e', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'Show diagnostic' }))
    map('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'Previous diagnostic' }))
    map('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'Next diagnostic' }))
    map('n', '<leader>cf', function() vim.lsp.buf.format({ async = true }) end,
      vim.tbl_extend('force', opts, { desc = 'Format buffer' }))
  end,
})
