DATA_PATH = vim.fn.stdpath("data")

local global = vim.g
local option = vim.o
local opt = vim.opt
local buffer_option = vim.bo
local window_option = vim.wo
local indent = 2

-- vim.lsp.set_log_level("debug")

global.mapleader = "," -- Set leader
global.maplocalleader = "," -- Set local leader
global.shada = "NONE"

option.shortmess = option.shortmess .. "I" -- Turn off splash
option.shortmess = option.shortmess .. "c" -- Avoid showing message extra message when using completion

option.cmdheight = 2 -- Set height to prevent 'press enter to continue'
option.hidden = true -- Allow to switch buffer without saving

opt.iskeyword:append("-")

-- option.completeopt = "menuone,noinsert,noselect"
option.completeopt = "menu,menuone,noselect"
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
option.showcmd = false -- Don't show commands

HOME_PATH = "/home/" .. vim.fn.expand("$USER")
option.undodir = HOME_PATH .. "/.config/nvim/undo" -- Save and set undo/redo levels
option.undofile = true
option.undolevels = 100
option.undoreload = 100
option.listchars = "tab:▸ ,trail:·,nbsp:␣,extends:❯,precedes:❮" -- Hidden chars

window_option.signcolumn = "yes" -- Always show signcolumn // number
window_option.number = true -- Show numbers
window_option.relativenumber = true -- Show relative numbers
window_option.signcolumn = "yes" -- Make room for gitsigns + numbers
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
global.loaded_perl_provider = 0
global.loaded_python_provider = 0

option.termguicolors = true

option.swapfile = false
option.conceallevel = 0 -- so that `` is visible in markdown files

option.splitbelow = true
option.splitright = true

option.mouse = ""
vim.wo.cursorline = true
