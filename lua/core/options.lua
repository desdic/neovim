DATA_PATH = vim.fn.stdpath("data")
HOME_PATH = vim.env.HOME

vim.fn.mkdir(vim.fn.stdpath("data") .. "site/spell", "p") -- make sure spelldir is created

local g = vim.g -- Global
local o = vim.o -- Options
local opt = vim.opt
local bo = vim.bo -- Buffer option
local wo = vim.wo -- Window option

vim.lsp.set_log_level("OFF") -- turn complely off when not during 'debug'

g.personal_projects_dir = HOME_PATH .. "/src/private"
g.work_projects_dir = HOME_PATH .. "/git"
g.mapleader = "," -- Set leader
g.maplocalleader = "," -- Set local leader
g.shada = "NONE"
g.markdown_fenched_languages = { "lua", "c", "cpp", "go", "ruby" } -- Fix highligts within markdown files
g.splitkeep = "screen" -- stabilize buffer content
-- Disable healthcheck
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_node_provider = 0

opt.guicursor = "" -- Use fat cursor
opt.shortmess:append("I") -- Turn off splash
opt.shortmess:append("c") -- Avoid showing message extra message when using completion
opt.shortmess:append("s") -- Don't give "search hit BOTTOM, continuing at TOP" or "search
opt.formatoptions:append({ "n" }) -- Better indent
opt.iskeyword:append("-") -- Add - to be part of word
opt.nrformats:append("unsigned") -- Increment
opt.spelllang = { "en", "da" }
g.spellfile_URL = "https://ftp.nluug.nl/vim/runtime/spell/"
opt.shell = "zsh"
opt.isfname:append("@-@") -- Include @ in filename

-- Default to tabs, override with .editorconfig
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true

o.cmdheight = 2 -- Set height to prevent 'press enter to continue'
o.hidden = true -- Allow to switch buffer without saving
o.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
o.jumpoptions = "view" -- save 'view' when jumping
o.updatetime = 300 -- Faster completion
o.showmode = false -- We don't need to see things like -- INSERT -- anymore
o.ruler = true -- Make search act like search in modern browsers
o.incsearch = true
o.hlsearch = false -- No search highlight
o.backup = false -- Don't use backup
o.writebackup = false
o.showmatch = true -- Show matching braces
o.synmaxcol = 500 -- Stop syntax highlight on long lines
o.wrap = false -- Don't wrap lines
o.textwidth = 0 -- Don't add newline after 80 chars
o.scrolloff = 10 -- Always keep 10 lines visible
o.errorbells = false -- Disable error bells
o.showcmd = false -- Don't show commands
o.undodir = DATA_PATH .. "/undo" -- Save and set undo/redo levels
o.undofile = true
o.undolevels = 100
o.undoreload = 100
o.listchars = "tab:▸ ,trail:·,nbsp:␣,extends:❯,precedes:❮" -- Hidden chars
-- o.clipboard = "unnamedplus"
o.foldenable = false
o.swapfile = true
o.conceallevel = 0 -- so that `` is visible in markdown files
o.splitbelow = true
o.splitright = true
o.mouse = "a"
o.pumheight = 10 -- Maximum number of entries in a popup
o.winborder = "rounded" -- Give all floating windows a border

wo.signcolumn = "yes" -- Always show signcolumn // number
wo.number = true -- Show numbers
wo.relativenumber = true -- Show relative numbers
wo.list = true -- Show hidden chars
wo.cursorline = true

bo.scrollback = 10000

vim.cmd("let g:netrw_liststyle = 3")
