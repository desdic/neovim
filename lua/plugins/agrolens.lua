vim.pack.add({
    { src = "https://github.com/desdic/agrolens.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    require("agrolens").setup({
        debug = false,
        force_long_filepath = false,
        same_type = false,
        include_hidden_buffers = false,
        disable_indentation = true,
        aliases = {
            yamllist = "docker-compose,github-workflow-steps",
            work = "cheflxchost,github-workflow-steps,pytest,ipam",
            all = "cheflxchost,pytest,ipam,functions,labels",
        },
    })

    vim.keymap.set("n", "<leader>ag", function()
        require("agrolens").generate({ all_captures = true })
    end, { desc = "AL generate" })

    vim.keymap.set("n", "zu", function()
        require("agrolens.snacks").run({
            query = "functions,labels",
        })
    end, { desc = "AL func,label cur buffer" })

    vim.keymap.set("n", "zi", function()
        require("agrolens.snacks").run({
            query = "functions,labels",
            buffers = "all",
            same_type = false,
        })
    end, { desc = "AL func,label all buffers" })

    vim.keymap.set("n", "zo", function()
        require("agrolens.snacks").run({
            query = "callings",
            buffers = "all",
            same_type = false,
            match = "name,object",
        })
    end, { desc = "AL callings of name" })

    vim.keymap.set("n", "zl", function()
        require("agrolens.snacks").run({
            query = "work",
        })
    end, { desc = "AL work profile" })

    vim.keymap.set("n", "zc", function()
        require("agrolens.snacks").run({
            query = "comments",
            buffers = "all",
            same_type = false,
        })
    end, { desc = "AL comments" })

    vim.keymap.set("n", "z[", function()
        require("agrolens.snacks").run({
            query = "all",
            jump = "next",
        })
    end, { desc = "AL jump next" })

    vim.keymap.set("n", "z]", function()
        require("agrolens.snacks").run({
            query = "all",
            jump = "prev",
        })
    end, { desc = "AL jump previous" })
end, 500)
