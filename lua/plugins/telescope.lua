local M = {
    enabled = false,
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        -- { "zu", "<cmd>Telescope agrolens query=functions,labels<CR>" },
        -- { "zi", "<cmd>Telescope agrolens query=functions,labels buffers=all same_type=false<CR>" },
        -- { "zo", "<cmd>Telescope agrolens query=callings buffers=all same_type=false match=name,object<CR>" },
        -- { "zl", "<cmd>Telescope agrolens query=work<CR>" },
        -- { "zc", "<cmd>Telescope agrolens query=comments buffers=all same_type=false<CR>" },
        -- { "z[", "<cmd>Telescope agrolens query=all jump=next<CR>" },
        -- { "z]", "<cmd>Telescope agrolens query=all jump=prev<CR>" },
    },
    dependencies = {
        { "nvim-telescope/telescope-fzy-native.nvim" },
        { "desdic/telescope-rooter.nvim" },
        { "nvim-tree/nvim-web-devicons" },
        { "desdic/macrothis.nvim" },
        -- { "desdic/agrolens.nvim" },
    },
}

function M.config()
    ---@diagnostic disable-next-line: different-requires
    local ts = require("telescope")

    local actions = require("telescope.actions")
    local empty = vim.empty or vim.tbl_isempty

    -- Open multiple files
    local select_one_or_multi = function(prompt_bufnr)
        local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        if not empty(multi) then
            require("telescope.actions").close(prompt_bufnr)
            for _, j in pairs(multi) do
                if j.path ~= nil then
                    vim.cmd(string.format("%s %s", "edit", j.path))
                end
            end
        else
            require("telescope.actions").select_default(prompt_bufnr)
        end
    end

    ts.setup({
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
                    ["<CR>"] = actions.select_default + actions.center,
                    ["<C-o>"] = select_one_or_multi,
                },
                n = {
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                    ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                    ["<C-o>"] = select_one_or_multi,
                },
            },
        },
        extensions = {
            fzy_native = { override_generic_sorter = false, override_file_sorter = true },
            rooter = { patterns = { ".git", "go.sum", "Makefile" } },
            -- agrolens = {
            --     debug = false,
            --     same_type = false,
            --     include_hidden_buffers = false,
            --     disable_indentation = true,
            --     aliases = {
            --         yamllist = "docker-compose,github-workflow-steps",
            --         work = "cheflxchost,github-workflow-steps,pytest,ipam",
            --         all = "cheflxchost,pytest,ipam,functions,labels",
            --     },
            -- },
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
    -- ts.load_extension("agrolens")
    ts.load_extension("macrothis")
end

return M
