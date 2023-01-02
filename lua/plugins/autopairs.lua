local M = {"windwp/nvim-autopairs", event = "VeryLazy"}

function M.config()
    local ap = require("nvim-autopairs")

    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if not cmp_status_ok then return end

    ap.setup({check_ts = true, ts_config = {lua = {"string", "source"}}})

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
end

return M
