local ok, ap = pcall(require, "nvim-autopairs")
if not ok then
    vim.notify("Unable to require nvim-autopairs", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then return end

ap.setup({check_ts = true, ts_config = {lua = {"string", "source"}}})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
