local M = {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    cmd = "Telescope",
    keys = {
        {
            "<Leader>vrc",
            function()
                require("custom.telescope").search_nvim()
            end,
        },
        {
            "<Leader>notes",
            function()
                require("custom.telescope").grep_notes()
            end,
            desc = "",
        },
        {
            "<Leader>ff",
            function()
                require("telescope.builtin").find_files({
                    hidden = true,

                    -- find_command = {
                    --     "fd", "--type", "f", "--hidden", "--no-ignore", "--color=never"
                    -- }
                })
            end,
            desc = "[F]ind [f]iles",
        },
        {
            "<Leader>fg",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "[F]ile [g]rep",
        },
        {
            "<Leader>sm",
            function()
                require("telescope.builtin").marks()
            end,
            desc = "[S]how [m]arks",
        },
        {
            "<Leader>ts",
            function()
                require("telescope.builtin").treesitter()
            end,
            desc = "[T]reesitter [s]ymbols",
        },
        {
            "<Leader>sb",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "[S]how [b]uffers",
        },
        {
            "<Leader>ht",
            function()
                require("telescope.builtin").help_tags()
            end,
            desc = "[H]elp [t]ags",
        },
        {
            "<Leader>ln",
            function()
                require("telescope").extensions.notify.notify({})
            end,
            desc = "[L]ist [n]otifications",
        },
        {
            "<Leader>fs",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "[F]uzzy [s]earch",
        },
        {
            "<Leader>gS",
            function()
                require("telescope.builtin").git_status()
            end,
            desc = "[G]it [s]tatus",
        },
        { "<Leader>hm", "<cmd>Telescope harpoon marks<CR>", desc = "[H]arpoon [m]arks" },
        { "zu", "<cmd>Telescope agrolens query=functions,labels<CR>" },
        { "zi", "<cmd>Telescope agrolens query=functions,labels buffers=all same_type=false<CR>" },
        { "zo", "<cmd>Telescope agrolens query=callings buffers=all same_type=false match=name,object<CR>" },
        { "zl", "<cmd>Telescope agrolens query=cheflxchost,github-workflow-steps<CR>" },
        { "zc", "<cmd>Telescope agrolens query=comments buffers=all same_type=false<CR>" },
    },
    dependencies = {
        { "nvim-telescope/telescope-fzy-native.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "desdic/telescope-rooter.nvim" },
        { "nvim-tree/nvim-web-devicons" },
        {
            "desdic/agrolens.nvim",
            dev = false,
            event = "VeryLazy",
            keys = {
                {
                    "ag",
                    function()
                        require("agrolens").generate({ all_captures = true })
                    end,
                },
            },
        },
    },
}

function M.config()
    local ts = require("telescope")

    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local trouble = require("trouble.providers.telescope")

    ts.setup({
        pickers = {
            -- Make telescope able to jump to a specific line
            find_files = {
                on_input_filter_cb = function(prompt)
                    local find_colon = string.find(prompt, ":")
                    if find_colon then
                        local ret = string.sub(prompt, 1, find_colon - 1)
                        vim.schedule(function()
                            local prompt_bufnr = vim.api.nvim_get_current_buf()
                            local state = action_state.get_current_picker(prompt_bufnr).previewer.state
                            local lnum = tonumber(prompt:sub(find_colon + 1))

                            if type(lnum) == "number" then
                                if state then
                                    local win = tonumber(state.winid)
                                    local bufnr = tonumber(state.bufnr)
                                    local line_count = vim.api.nvim_buf_line_count(bufnr)
                                    vim.api.nvim_win_set_cursor(win, { math.max(1, math.min(lnum, line_count)), 0 })
                                end
                            end
                        end)
                        local selection = action_state.get_selected_entry()
                        if selection then
                            ret = selection[1]
                        end
                        return { prompt = ret }
                    end
                end,
                attach_mappings = function()
                    actions.select_default:enhance({
                        post = function()
                            local prompt = action_state.get_current_line()
                            local find_colon = string.find(prompt, ":")
                            if find_colon then
                                local lnum = tonumber(prompt:sub(find_colon + 1))
                                vim.api.nvim_win_set_cursor(0, { lnum, 0 })
                            end
                        end,
                    })
                    return true
                end,
            },
        },
        defaults = {
            file_ignore_patterns = { "^.git/", "^.cache/", "vendor" },
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = { "smart" },

            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<esc>"] = actions.close,
                    ["<c-t>"] = trouble.open_with_trouble,
                    -- ["<CR>"] = actions.select_default + actions.center,

                    -- You can perform as many actions in a row as you like
                    -- ["<CR>"] = actions.select_default + actions.center + my_cool_custom_action,
                    -- ["<C-h>"] = actions.which_key -- keys from pressing <C-/>
                },
                n = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<c-t>"] = trouble.open_with_trouble,
                    -- ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    -- ["<C-h>"] = actions.which_key
                },
            },
        },
        extensions = {
            fzy_native = { override_generic_sorter = false, override_file_sorter = true },
            rooter = { patterns = { ".git", "go.sum" } },
            agrolens = {
                debug = false,
                same_type = false,
                include_hidden_buffers = false,
                disable_indentation = true,
                aliases = { yamllist = "docker-compose,github-workflow-steps" },
            },
        },
    })

    ts.load_extension("fzy_native")
    ts.load_extension("harpoon")
    ts.load_extension("rooter")
    ts.load_extension("agrolens")
end

return M
