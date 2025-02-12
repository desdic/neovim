return {
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
    opts = {},
    config = function()
        local privaterepo = os.getenv("GOPRIVATE")
        if privaterepo then
            local gitlinker = require("gitlinker")

            gitlinker.setup({
                callbacks = {
                    [privaterepo] = gitlinker.hosts.get_gitlab_type_url,
                },
            })
        end
    end,
    keys = {
        {
            "<leader>go",
            '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        },
    },
}
