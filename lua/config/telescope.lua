local ok, ts = pcall(require, "telescope")
if not ok then
    vim.notify("Unable to require telescope", "error")
    return
end

local actionok, actions = pcall(require, "telescope.actions")
if not actionok then
    vim.notify("Unable to require telescope.actions", "error")
    return
end

ts.setup({
    defaults = {
        -- set_env = {['COLORTERM'] = 'truecolor'}, -- default = nil,

        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                -- To disable a keymap, put [map] = false
                -- So, to not map "<C-n>", just put
                -- ["<c-x>"] = false,
                ["<esc>"] = actions.close,

                -- Otherwise, just set the mapping to the function that you want it to be.
                -- ["<C-i>"] = actions.select_horizontal,

                -- Add up multiple actions
                ["<CR>"] = actions.select_default + actions.center

                -- You can perform as many actions in a row as you like
                -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist
                -- ["<C-i>"] = my_cool_custom_action,
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
        }
    }
})

require("telescope").load_extension("fzy_native")
require("telescope").load_extension("media_files")

local M = {}

M.find_files = function()
    require("telescope.builtin").find_files({
        find_command = {"rg", "--files", "--hidden", "-g", "!.git"},
        previewer = false
    })
end

M.search_nvim = function()
    require("telescope.builtin").find_files({
        prompt_title = "< VimRC >",
        cwd = "$HOME/.config/nvim/"
    })
end

function M.grep_notes()
    local opts = {}
    opts.search_dirs = {"~/notes/"}
    opts.prompt_prefix = "   "
    opts.prompt_title = "Search Notes"
    require("telescope.builtin").live_grep(opts)
end

return M
