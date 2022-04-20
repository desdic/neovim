local status_ok, lualine = pcall(require, "lualine")
if not status_ok then return end

local hide_in_width = function() return vim.fn.winwidth(0) > 80 end

local diagnostics = {
    "diagnostics",
    sources = {"nvim_diagnostic"},
    sections = {"error", "warn"},
    symbols = {error = " ", warn = " "},
    colored = false,
    update_in_insert = false,
    always_visible = true
}

local diff = {
    "diff",
    colored = false,
    symbols = {added = " ", modified = " ", removed = " "}, -- changes diff symbols
    cond = hide_in_width
}

local mode = {"mode", fmt = function(str) return "-- " .. str .. " --" end}

local filetype = {
    function()
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        if buf_ft == "toggleterm" then return "" end
        return buf_ft
    end,
    icons_enabled = false,
    icon = nil
}

local branch = {"branch", icons_enabled = true, icon = ""}

local location = {"location", padding = 0}

local lspclients = {
    function()
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then return "" end
        return ""
    end,
    padding = {right = 1},
    cond = hide_in_width
}

local spaces = function()
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    if buf_ft == "toggleterm" then return "" end
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local filename = function()
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    if buf_ft == "toggleterm" then return "terminal" end
    return vim.fn.expand("%:t")
end

-- override the inactive background for filename to be more visible
local custom_catppuccin = {}
local cstatus_ok, catcolors = pcall(require, "catppuccin.api.colors")
if cstatus_ok then
    cstatus_ok, custom_catppuccin = pcall(require, "lualine.themes.catppuccin")
    if cstatus_ok then
        local colors = catcolors.get_colors()
        custom_catppuccin.inactive.c.bg = colors.black1
    end
end

lualine.setup({
    options = {
        icons_enabled = true,
        theme = 'tokyonight',
        -- theme = custom_catppuccin,
        -- theme = "nightfox",
        component_separators = {left = "", right = ""},
        section_separators = {left = "", right = ""},
        disabled_filetypes = {"dashboard", "NvimTree", "Outline"},
        always_divide_middle = true,
		globalstatus = true
    },
    sections = {
        lualine_a = {branch, diagnostics},
        lualine_b = {mode},
        lualine_c = {},
        lualine_x = {lspclients, "%=", diff, spaces, "encoding", filetype},
        lualine_y = {location},
        lualine_z = {}
        -- lualine_z = {progress}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {"%=", filename},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {}
})
