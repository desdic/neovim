local ok, ts = pcall(require, "telescope")
if not ok then
    vim.notify("Unable to require telescope", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local actionok, actions = pcall(require, "telescope.actions")
if not actionok then
    vim.notify("Unable to require telescope.actions", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local buildok, tsbuildin = pcall(require, "telescope.builtin")
if not buildok then
    vim.notify("Unable to require telescope.builin", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

ts.setup({
    defaults = {
        file_ignore_patterns = {".git/", ".cache/", "vendor"},
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = {"smart"},

        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                -- ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<esc>"] = actions.close,
                -- ["<CR>"] = actions.select_default + actions.center,

                -- You can perform as many actions in a row as you like
                -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
                -- ["<C-h>"] = actions.which_key -- keys from pressing <C-/>
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                -- ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                -- ["<C-h>"] = actions.which_key
            }
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true
        },
        media_files = {
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = {"png", "webp", "jpg", "jpeg", "pdf"},
            find_cmd = "rg" -- find command (defaults to `fd`)
        },
        file_browser = {
            hijack_netrw = true,
             mappings = {
                 ["i"] = {
                     -- your custom insert mode mappings
                 },
                 ["n"] = {
                     -- your custom normal mode mappings
                 }
             }
        }
    }
})

ts.load_extension("fzy_native")
ts.load_extension("media_files")
ts.load_extension("file_browser")
ts.load_extension('harpoon')

vim.keymap.set("n", "<Leader>fa", function() tsbuildin.marks() end,
               {noremap = true, silent = true, desc = "Show marks"})

vim.keymap.set("n", "<Leader>ff",
               function() tsbuildin.find_files({hidden = true}) end,
               {noremap = true, silent = true, desc = "Find files"})

vim.keymap.set("n", "<Leader>fv", function() tsbuildin.treesitter() end,
               {noremap = true, silent = true, desc = "Find variables"})

vim.keymap.set("n", "<Leader>fm",
               function() ts.extensions.media_files.media_files() end,
               {noremap = true, silent = true, desc = "Find media files"})

vim.keymap.set("n", "<Leader>fg", function() tsbuildin.live_grep() end,
               {noremap = true, silent = true, desc = "Live grep"})

vim.keymap.set("n", "<Leader>fb", function() tsbuildin.buffers() end,
               {noremap = true, silent = true, desc = "Show buffers"})

vim.keymap.set("n", "<Leader>fh", function() tsbuildin.help_tags() end,
               {noremap = true, silent = true, desc = "Help tags"})

vim.keymap.set("n", "<Leader>fn",
               function() ts.extensions.notify.notify({}) end,
               {noremap = true, silent = true, desc = "List notifications"})

vim.keymap.set("n", "<Leader>fo",
               function() tsbuildin.tags({only_current_buffer = true}) end,
               {noremap = true, silent = true, desc = "List tags"})

vim.keymap.set("n", "<Leader>fs",
               function() tsbuildin.current_buffer_fuzzy_find() end,
               {noremap = true, silent = true, desc = "Fuzzy find in buffer"})

vim.keymap.set("n", "<Leader>gS", function() tsbuildin.git_status() end,
               {noremap = true, silent = true, desc = "Git status"})

vim.keymap.set("n", "<Leader>p", function() tsbuildin.diagnostics() end,
               {noremap = true, silent = true, desc = "Show diagnostics"})

vim.keymap.set("n", "<Leader>n", ":Telescope file_browser<CR>",
               {noremap = true, silent = true, desc = "Start file browser"})

-- <C+d> to delete
-- <C+n> move down
vim.keymap.set("n", "<Leader>hm", ":Telescope harpoon marks<CR>",
               {noremap = true, silent = true, desc = "Harpoon marks"})

local M = {}

M.find_files = function()
    tsbuildin.find_files({
        find_command = {"fd", "-t=f", "-a"},
        -- path_display = {"absolute"},
        wrap_results = true
        -- previewer = false
    })
end

M.search_nvim = function()
    tsbuildin.find_files({
        prompt_title = "< VimRC >",
        cwd = "$HOME/.config/nvim/"
    })
end

function M.grep_notes()
    local optsgrep = {}
    optsgrep.search_dirs = {"~/notes/"}
    optsgrep.prompt_prefix = "   "
    optsgrep.prompt_title = "Search Notes"
    tsbuildin.live_grep(optsgrep)
end

function M.list_methods()
    local symopts = {symbols = {"function", "method", "constructor"}}
    if vim.bo.filetype == "vim" then symopts.symbols = {"function"} end
    tsbuildin.lsp_document_symbols(symopts)
end

vim.keymap.set("n", "<Leader>vrc", function() M.search_nvim() end, {
    noremap = true,
    silent = true,
    desc = "Search in neovim config"
})

vim.keymap.set("n", "<Leader>notes", function() M.grep_notes() end,
               {noremap = true, silent = true, desc = "Search in notes"})

vim.keymap.set("n", "<Leader>m", function() M.list_methods() end,
               {noremap = true, silent = true, desc = "List methods"})

return M
