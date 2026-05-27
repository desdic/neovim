vim.opt.showtabline = 2

function _G.BuildInTabline()
    local s = " "

    local bufs = vim.fn.getbufinfo({ buflisted = 1 })
    local current_buf = vim.api.nvim_get_current_buf()

    for _, buf in ipairs(bufs) do
        local bufnr = buf.bufnr
        local name = vim.fn.fnamemodify(buf.name, ":t")

        if name == "" then
            name = "[No Name]"
        end

        local is_active = (bufnr == current_buf)
        local base_hl = is_active and "%#TabLineSel#" or "%#TabLine#"

        s = s .. base_hl
        -- s = s .. " " .. bufnr .. " "

        local icon_str = require("core.utils").get_mini_file_icon(name, is_active)
        if icon_str ~= "" then
            s = s .. icon_str .. " "
        end

        s = s .. base_hl .. name

        if vim.fn.getbufvar(bufnr, "&modified") == 1 then
            s = s .. " +"
        end

        s = s .. " "
    end

    -- Fill the rest of the tabline with the standard background highlight
    s = s .. "%#TabLineFill#%="
    return s
end

vim.opt.tabline = "%!v:lua.BuildInTabline()"
