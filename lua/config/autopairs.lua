local ok, ap = pcall(require, "nvim-autopairs")
if not ok then
    vim.notify("Unable to require nvim-autopairs", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

ap.setup({
    check_ts = true,
    ts_config = {lua = {"string", "source"}},
    disable_filetype = {"TelescopePrompt"},
    fast_wrap = {
        map = "<M-e>",
        chars = {"{", "[", "(", '"', "'"},
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = -1, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr"
    }
})

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
