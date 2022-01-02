local cmd = vim.cmd
-- local api = vim.api
local global = vim.g
local option = vim.o
local opt = vim.opt
local buffer_option = vim.bo
local window_option = vim.wo
local indent = 2

-- vim.lsp.set_log_level("debug")

global.mapleader = ',' -- Set leader
global.shada = "NONE"

-- If using a Neovim version earlier than 0.6.0 (nathom/filetype.nvim)
global.did_load_filetypes = 1

option.shortmess = option.shortmess .. 'I' -- Turn off splash
option.shortmess = option.shortmess .. 'c' -- Avoid showing message extra message when using completion

option.cmdheight = 2 -- Set height to prevent 'press enter to continue'
option.hidden = true -- Allow to switch buffer without saving
option.iskeyword = option.iskeyword:gsub('_,', '') -- Setup word boundry on _
--option.completeopt = "menuone,noinsert,noselect"
option.completeopt = "menuone,noselect"
option.updatetime = 300 -- Faster completion

option.showmode = false -- We don't need to see things like -- INSERT -- anymore
option.ruler = true -- Make search act like search in modern browsers
option.incsearch = true
option.hlsearch = false -- No search highlight
option.backup = false -- Don't use swap or backup
option.writebackup = false

option.showmatch = true -- Show matching braces
option.synmaxcol = 500 -- Stop syntax highlight on long lines
option.wrap = false -- Don't wrap lines
option.textwidth = 0 -- Don't add newline after 80 chars
option.scrolloff = 10 -- Always keep 10 lines visible
option.errorbells = false -- Disable error bells
option.showcmd = true -- Show the (partial) command as it’s being typed

option.undodir = HOME_PATH .. "/.config/nvim/undo" -- Save and set undo/redo levels
option.undofile = true
option.undolevels = 100
option.undoreload = 100

window_option.signcolumn = 'number' -- Always show signcolumn
window_option.number = true -- Show numbers
window_option.relativenumber = true -- Show relative numbers
window_option.signcolumn = "yes" -- Make room for gitsigns + numbers

window_option.listchars = 'tab:▸ ,trail:·,nbsp:_,eol:↴' -- Hidden chars

window_option.list = true -- Show hidden chars

buffer_option.tabstop = indent -- Default set to spaces
buffer_option.shiftwidth = indent
buffer_option.expandtab = true
buffer_option.autoindent = true
buffer_option.smartindent = true

opt.termguicolors = true

-- Remove artifacts/redraw issue from indent-blankline.nvim
vim.wo.colorcolumn = "99999"

-- Disable healthcheck
global.loaded_perl_provider=0
-- global.loaded_python_provider=0


cmd 'syntax enable'
-- option.background = 'dark'
option.termguicolors = true
window_option.cursorline = true
cmd 'colorscheme catppuccin'

cmd("set noswapfile")
cmd("filetype plugin on")

-- Fix background in diagnostics and floating by using catppuccin1 as BG
-- Would like to use #1E1E28 but since LspInfo doesn't have borders so I have chosen #1B1923
vim.cmd [[ highlight DiagnosticError guibg=#1B1923 ]]
vim.cmd [[ highlight NormalFloat guibg=#1B1923 ]]
