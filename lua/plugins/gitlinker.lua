vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/ruifm/gitlinker.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    local gitlinker = require("gitlinker")
    local callbacks = {}

    local privaterepo = os.getenv("GITLABS")
    if privaterepo then
        for repo in string.gmatch(privaterepo, "([^,]+)") do
            callbacks[repo] = gitlinker.hosts.get_gitlab_type_url
        end
    end

    gitlinker.setup({
        callbacks = callbacks,
    })

    vim.keymap.set(
        "n",
        "<leader>go",
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { desc = "Open gitlink" }
    )
end, 500)
