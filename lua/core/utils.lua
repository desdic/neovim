local M = {}

M.pack_clean = function()
    local unused_plugins = {}

    for _, plugin in ipairs(vim.pack.get()) do
        if plugin.active ~= true then
            table.insert(unused_plugins, plugin.spec.name)
        end
    end

    if #unused_plugins == 0 then
        vim.print("No unused plugins")
        return
    end

    local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
    if choice == 1 then
        vim.pack.del(unused_plugins)
    end
end

local function get_custom_icon_hl(icon_hl_group, is_active)
    local base_group = is_active and "TabLineSel" or "TabLine"

    if not is_active then
        return base_group
    end

    local custom_group = "TabLineIcon_" .. icon_hl_group .. "_" .. base_group

    if vim.fn.hlexists(custom_group) == 1 then
        return custom_group
    end

    local icon_hl = vim.api.nvim_get_hl(0, { name = icon_hl_group, link = false })
    local base_hl = vim.api.nvim_get_hl(0, { name = base_group, link = false })

    local fg = icon_hl.fg or base_hl.fg
    local bg = base_hl.bg

    vim.api.nvim_set_hl(0, custom_group, { fg = fg, bg = bg })
    return custom_group
end

M.get_mini_file_icon = function(filename, is_active)
    local has_minicons, miniicons = pcall(require, "mini.icons")
    if has_minicons then
        local icon, hl, _ = miniicons.get("file", filename)
        local dynamic_hl = get_custom_icon_hl(hl, is_active)
        return "%#" .. dynamic_hl .. "#" .. icon
    end
    return ""
end

M.trim = function(s)
    return s:match("^%s*(.-)%s*$")
end

return M
