local M = {
    "nvim-telescope/telescope.nvim",
    -- event = "VeryLazy",
    cmd = "Telescope",
    keys = {
        {
            "<Leader>vrc",
            function()
                require("core.telescope").search_nvim()
            end,
            desc = "Search nvim config",
        },
        {
            "<Leader>no",
            function()
                require("core.telescope").grep_notes()
            end,
            desc = "Search notes",
        },
        {
            "<Leader>ff",
            function()
                require("telescope.builtin").find_files({
                    hidden = true,
                    find_command = { "rg", "--files", "--sort", "path" },
                })
            end,
            desc = "[F]ind [f]iles",
        },
        {
            "<Leader>gf",
            function()
                require("telescope.builtin").git_files()
            end,
            desc = "[G]it [f]iles",
        },
        {
            "<Leader>gk",
            function()
                require("telescope.builtin").grep_string()
            end,
            desc = "[G]rep [k]key",
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
            "<Leader>ht",
            function()
                require("telescope.builtin").help_tags()
            end,
            desc = "[H]elp [t]ags",
        },
        {
            "<Leader>ln",
            "<cmd>Telescope notify<CR>",
            desc = "[L]ist [n]otifications",
        },
        {
            "<Leader>fz",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "[F]uzzy [s]earch",
        },
        {
            "<Leader>fb",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "[F]ile [b]buffers",
        },
        {
            "<Leader>ka",
            function()
                local qflist = vim.fn.getqflist()
                if qflist then
                    vim.cmd("cclose")
                    for _, element in ipairs(qflist) do
                        local filename = vim.api.nvim_buf_get_name(element.bufnr)
                        vim.cmd("e " .. filename)
                    end
                end
            end,
            desc = "Open files in listed in quickfix list",
        },
        { "zu", "<cmd>Telescope agrolens query=functions,labels<CR>" },
        { "zi", "<cmd>Telescope agrolens query=functions,labels buffers=all same_type=false<CR>" },
        { "zo", "<cmd>Telescope agrolens query=callings buffers=all same_type=false match=name,object<CR>" },
        { "zl", "<cmd>Telescope agrolens query=work<CR>" },
        { "zc", "<cmd>Telescope agrolens query=comments buffers=all same_type=false<CR>" },
        { "z[", "<cmd>Telescope agrolens query=all jump=next<CR>" },
        { "z]", "<cmd>Telescope agrolens query=all jump=prev<CR>" },
    },
    dependencies = {
        { "nvim-telescope/telescope-fzy-native.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "desdic/telescope-rooter.nvim" },
        { "nvim-tree/nvim-web-devicons" },
        { "desdic/macrothis.nvim" },
        { "desdic/agrolens.nvim" },
    },
}

function M.config()
    ---@diagnostic disable-next-line: different-requires
    local ts = require("telescope")

    local actions = require("telescope.actions")

    ts.setup({
        pickers = {
            -- Make telescope able to jump to a specific line
            find_files = {
                on_input_filter_cb = require("core.telescope").jump_to_line_filter,
                attach_mappings = require("core.telescope").jump_to_line_mapping,
            },
        },
        defaults = {
            file_ignore_patterns = { "^.git/", "^.cache/", "vendor", "^deps/mini.nvim/" },
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = { "smart" },
            sorting_strategy = "descending",

            mappings = {
                i = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
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
                },
            },
        },
        extensions = {
            fzy_native = { override_generic_sorter = false, override_file_sorter = true },
            rooter = { patterns = { ".git", "go.sum", "Makefile" } },
            agrolens = {
                debug = false,
                same_type = false,
                include_hidden_buffers = false,
                disable_indentation = true,
                aliases = {
                    yamllist = "docker-compose,github-workflow-steps",
                    work = "cheflxchost,github-workflow-steps,pytest,ipam",
                    all = "cheflxchost,pytest,ipam,functions,labels",
                },
            },
            macrothis = {
                -- mappings = {
                --     load = "<CR>",
                --     save = "<C-l>",
                --     delete = "<C-d>"
                -- }
            },
        },
    })

    ts.load_extension("fzy_native")
    ts.load_extension("rooter")
    ts.load_extension("agrolens")
    ts.load_extension("macrothis")
end

return M
