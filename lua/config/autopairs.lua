local ok, ap = pcall(require, "nvim-autopairs")
if not ok then
    vim.notify("Unable to require nvim-autopairs", "error")
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
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr"
    }
})
