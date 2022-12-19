local ok, ts = pcall(require, "telescope")
if not ok then
    vim.notify("Unable to require telescope", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

local actionok, actions = pcall(require, "telescope.actions")
if not actionok then
    vim.notify("Unable to require telescope.actions", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

local buildok, tsbuildin = pcall(require, "telescope.builtin")
if not buildok then
    vim.notify("Unable to require telescope.builin", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
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
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<esc>"] = actions.close
                -- ["<CR>"] = actions.select_default + actions.center,

                -- You can perform as many actions in a row as you like
                -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
                -- ["<C-h>"] = actions.which_key -- keys from pressing <C-/>
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous
                -- ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                -- ["<C-h>"] = actions.which_key
            }
        }
    },
    extensions = {
        fzy_native = {override_generic_sorter = false, override_file_sorter = true},
        rooter = {patterns = {".git", "go.sum"}}
    }
})

ts.load_extension("fzy_native")
ts.load_extension("harpoon")
ts.load_extension("rooter")

vim.keymap.set("n", "<Leader>sm", function() tsbuildin.marks() end,
               {noremap = true, silent = true, desc = "[S]how [m]arks"})

vim.keymap.set("n", "<Leader>ff", function() tsbuildin.find_files({hidden = true}) end,
               {noremap = true, silent = true, desc = "[F]ind [f]iles"})

vim.keymap.set("n", "<Leader>ts", function() tsbuildin.treesitter() end,
               {noremap = true, silent = true, desc = "[T]reesitter [s]ymbols"})

vim.keymap.set("n", "<Leader>fg", function() tsbuildin.live_grep() end,
               {noremap = true, silent = true, desc = "[F]ile [g]rep"})

vim.keymap.set("n", "<Leader>sb", function() tsbuildin.buffers() end,
               {noremap = true, silent = true, desc = "[S]how [b]uffers"})

vim.keymap.set("n", "<Leader>ht", function() tsbuildin.help_tags() end,
               {noremap = true, silent = true, desc = "[H]elp [t]ags"})

vim.keymap.set("n", "<Leader>ln", function() ts.extensions.notify.notify({}) end,
               {noremap = true, silent = true, desc = "[L]ist [n]otifications"})

vim.keymap.set("n", "<Leader>fs", function() tsbuildin.current_buffer_fuzzy_find() end,
               {noremap = true, silent = true, desc = "[F]uzzy [s]earch"})

vim.keymap.set("n", "<Leader>gS", function() tsbuildin.git_status() end,
               {noremap = true, silent = true, desc = "[G]it [s]tatus"})

-- <C+d> to delete
-- <C+n> move down
vim.keymap.set("n", "<Leader>hm", ":Telescope harpoon marks<CR>",
               {noremap = true, silent = true, desc = "[H]arpoon [m]arks"})

local M = {}

M.find_files = function()
    tsbuildin.find_files({
        find_command = {"fd", "-t=f", "-a"},
        -- path_display = {"absolute"},
        wrap_results = true
        -- previewer = false
    })
end

M.search_nvim = function() tsbuildin.find_files({prompt_title = "< VimRC >", cwd = "$HOME/.config/nvim/"}) end

function M.grep_notes()
    local optsgrep = {}
    optsgrep.search_dirs = {"~/notes/"}
    optsgrep.prompt_prefix = "   "
    optsgrep.prompt_title = "Search Notes"
    tsbuildin.live_grep(optsgrep)
end

vim.keymap.set("n", "<Leader>vrc", function() M.search_nvim() end,
               {noremap = true, silent = true, desc = "Search in neovim config"})

vim.keymap.set("n", "<Leader>notes", function() M.grep_notes() end,
               {noremap = true, silent = true, desc = "Search in notes"})

return M
