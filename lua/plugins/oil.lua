return {
    "stevearc/oil.nvim",
    opts = {
        view_options = {
            show_hidden = true,
        },
    },
    keys = {
        {
            "<leader>ne",
            "<cmd>Oil<CR>",
            desc = "Browse files/dirs",
        },
        {
            "<leader>re",
            function()
                local filename = vim.fn.expand("$HOME/tmp/sshfzf.cache")
                local file = io.open(filename, "rb")
                if file then
                    local lines = {}
                    for line in io.lines(filename) do
                        table.insert(lines, line)
                    end
                    file:close()
                    vim.ui.select(lines, { prompt = "Choose remote host" }, function(choice)
                        if choice then
                            vim.cmd("Oil oil-ssh://" .. choice .. "/")
                        end
                    end)
                end
            end,
            desc = "Browse remote files/dirs",
        },
    },
    cmd = { "Oil" },
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}
