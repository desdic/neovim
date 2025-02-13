return {
    "ruifm/gitlinker.nvim",
    requires = "nvim-lua/plenary.nvim",
    opts = {},
    config = function()
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
    end,
    keys = {
        {
            "<leader>go",
            '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        },
    },
}
