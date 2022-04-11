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
		file_ignore_patterns = {".git"},
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = {"smart"},

        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<esc>"] = actions.close,
                ["<CR>"] = actions.select_default + actions.center,

                -- You can perform as many actions in a row as you like
                -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
                ["<C-h>"] = actions.which_key -- keys from pressing <C-/>
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-h>"] = actions.which_key
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
		["ui-select"] = {
			require("telescope.themes").get_dropdown {
				-- even more opts
			}
		}
    }
})

ts.load_extension("fzy_native")
ts.load_extension("media_files")
ts.load_extension("ui-select")

local keymap = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

keymap("n", "<Leader>a", ':lua require("telescope.builtin").marks()<CR>', opts)
keymap("n", "<Leader>ff",
       ':lua require("telescope.builtin").find_files({hidden=true})<CR>', opts)
keymap("n", "<Leader>fv", ':lua require("telescope.builtin").treesitter()<CR>',
       opts)
keymap("n", "<Leader>fm",
       ':lua require("telescope").extensions.media_files.media_files()<CR>',
       opts)
keymap("n", "<Leader>fg", ':lua require("telescope.builtin").live_grep()<CR>',
       opts)
keymap("n", "<Leader>fb", ':lua require("telescope.builtin").buffers()<CR>',
       opts)
keymap("n", "<Leader>fh", ':lua require("telescope.builtin").help_tags()<CR>',
       opts)
keymap("n", "<Leader>fn",
       ':lua require("telescope").extensions.notify.notify({})<CR>', opts)
keymap("n", "<Leader>fo",
       ':lua require("telescope.builtin").tags{ only_current_buffer = true }<CR>',
       opts)
keymap("n", "<Leader>vrc", ':lua require("config.telescope").search_nvim()<CR>',
       opts)
keymap("n", "<Leader>notes",
       ':lua require("config.telescope").grep_notes()<CR>', opts)
keymap("n", "<Leader>p", ":Telescope diagnostics<CR>", opts)
keymap("n", "<Leader>fs",
       ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", opts)
keymap("n", "<Leader>gS", ":lua require('telescope.builtin').git_status()<CR>",
       opts)
keymap("n", "<Leader>m",
       ':lua require("config.telescope").list_methods()<CR>', opts)

local M = {}

M.find_files = function()
    tsbuildin.find_files({
        find_command = {"rg", "--files", "--hidden", "-g", "!.git"},
        previewer = false
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

return M
