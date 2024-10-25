return {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
        { "<c-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle term", mode = { "n", "t" } },
        { "<leader>tts", "<cmd>TermSelect<cr>", desc = "Toggle term select" },
        {
            "<leader>lg",
            function()
                local Terminal = require("toggleterm.terminal").Terminal
                local lazygit = Terminal:new({
                    cmd = "lazygit",
                    dir = "git_dir",
                    direction = "float",
                    -- 90% width and height
                    float_opts = {
                        width = math.floor(vim.o.columns * 0.9),
                        height = math.floor(vim.o.lines * 0.9),
                    },
                    -- function to run on opening the terminal
                    on_open = function(term)
                        vim.cmd("startinsert!")
                        vim.api.nvim_buf_set_keymap(
                            term.bufnr,
                            "n",
                            "q",
                            "<cmd>close<CR>",
                            { noremap = true, silent = true }
                        )

                        -- Allow to make it work for lazygit for Esc and ctrl + hjkl
                        vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = term.bufnr, nowait = true })
                        vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = term.bufnr, nowait = true })
                        vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = term.bufnr, nowait = true })
                        vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = term.bufnr, nowait = true })
                        vim.keymap.set("t", "<esc>", "<esc>", { buffer = term.bufnr, nowait = true })
                    end,
                    -- function to run on closing the terminal
                    on_close = function(_)
                        vim.cmd("startinsert!")
                    end,
                })

                lazygit:toggle()
            end,
            desc = "Lazygit Toggle",
            mode = "n",
        },
    },
    version = "*",
    opts = {
        size = 20,
        open_mapping = [[<c-t>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
            border = "curved",
            winblend = 0,
            highlights = { border = "Normal", background = "Normal" },
        },
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        ---@diagnostic disable-next-line: duplicate-set-field
        function _G.set_terminal_keymaps()
            vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true, buffer = 0, desc = "Esc in terminal" })
            vim.keymap.set("t", "jk", [[<C-\><C-n>]], { noremap = true, buffer = 0, desc = "Esc in terminal" })
            vim.keymap.set(
                "t",
                "<C-h>",
                [[<C-\><C-n><C-W>h]],
                { noremap = true, buffer = 0, desc = "Navigate to left window" }
            )
            vim.keymap.set(
                "t",
                "<C-j>",
                [[<C-\><C-n><C-W>j]],
                { noremap = true, buffer = 0, desc = "Navigate to window below" }
            )
            vim.keymap.set(
                "t",
                "<C-k>",
                [[<C-\><C-n><C-W>k]],
                { noremap = true, buffer = 0, desc = "Navigate to window above" }
            )
            vim.keymap.set(
                "t",
                "<C-l>",
                [[<C-\><C-n><C-W>l]],
                { noremap = true, buffer = 0, desc = "Navigate to right window" }
            )
        end

        vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,
}
