local M = {}

local function setup_hl()
    local mocha = {
        bg = "#1e1e2e",
        base = "#11111b",
        special = "#3d3f57",
        n = "#89b4fa", -- Blue
        i = "#a6e3a1", -- Green
        v = "#cba6f7", -- Mauve
        r = "#f38ba8", -- Red
        c = "#fab387", -- Peach
    }

    local modes = {
        n = { name = "Normal", cols = mocha.n },
        i = { name = "Insert", cols = mocha.i },
        v = { name = "Visual", cols = mocha.v },
        r = { name = "Replace", cols = mocha.r },
        c = { name = "Command", cols = mocha.c },
    }

    for _, m in pairs(modes) do
        vim.api.nvim_set_hl(0, "SL" .. m.name .. "Norm", { fg = mocha.base, bg = m.cols, bold = true })
        vim.api.nvim_set_hl(0, "SL" .. m.name .. "Invert", { fg = m.cols, bg = mocha.base, bold = true })
        vim.api.nvim_set_hl(0, "SL" .. m.name .. "Left", { fg = m.cols, bg = mocha.special, bold = true })
        vim.api.nvim_set_hl(0, "SL" .. m.name .. "Right", { fg = mocha.special, bg = mocha.bg, bold = true })
    end
    vim.api.nvim_set_hl(0, "SLBG", { bg = mocha.bg, bold = true })
    vim.api.nvim_set_hl(0, "SLARROW", { fg = mocha.special, bg = mocha.bg, bold = true })
end

setup_hl()

local function get_file_icon(filename, extension)
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    if has_devicons then
        local icon, _ = devicons.get_icon(filename, extension, { default = true })
        return icon
    end
    return " "
end

local function get_diagnostic_count(severity)
    if not vim.diagnostic.is_enabled() then
        return 0
    end

    -- 0 refers to the current buffer
    local count = #vim.diagnostic.get(0, { severity = severity })
    return count > 0 and count or 0
end

local function statusline_diagnostics()
    local errors = get_diagnostic_count(vim.diagnostic.severity.ERROR)
    local warnings = get_diagnostic_count(vim.diagnostic.severity.WARN)

    return "  " .. errors .. "  " .. warnings .. " "
end

local spaces = function()
    local opt = { buf = 0 }
    local buf_ft = vim.api.nvim_get_option_value("filetype", opt)
    if buf_ft == "toggleterm" then
        return ""
    end

    local indent = "tabs"
    if vim.api.nvim_get_option_value("expandtab", opt) then
        indent = "spaces"
    end

    return indent .. ":" .. vim.api.nvim_get_option_value("shiftwidth", opt)
end

local marlin_component = function()
    local have_marlin, marlin = pcall(require, "marlin")
    if not have_marlin then
        return ""
    end
    local indexes = marlin.num_indexes()
    if indexes == 0 then
        return ""
    end
    local cur_index = marlin.cur_index()

    return "   " .. cur_index .. "/" .. indexes
end

local function get_git_branch()
    local gs = vim.b.gitsigns_status_dict
    if not gs or gs.head == "" then
        return ""
    end

    local branch = "  " .. gs.head

    return string.format("%s", branch)
end

vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local value = ev.data.params.value

        if value.kind ~= "end" and "running" or "success" then
            if value.kind == "end" then
                LSPPROGRESS = ""
            else
                local pct = value.percentage or ""
                LSPPROGRESS = table.concat({
                    "󱥸 ",
                    string.format("%s ", pct),
                    string.format("%s", value.title),
                })
            end
        end
    end,
})

local lsp_progress_component = function()
    return LSPPROGRESS or ""
end

function M.update()
    local mode_settings = {
        ["n"] = { name = "N", hl = "Normal" },
        ["no"] = { name = "OP-PENDING", hl = "Pending" },
        ["nov"] = { name = "OP-PENDING", hl = "Pending" },
        ["noV"] = { name = "OP-PENDING", hl = "Pending" },
        ["no\22"] = { name = "OP-PENDING", hl = "Pending" },
        ["niI"] = { name = "N", hl = "Normal" },
        ["niR"] = { name = "N", hl = "Normal" },
        ["niV"] = { name = "N", hl = "Normal" },
        ["nt"] = { name = "N", hl = "Normal" },
        ["ntT"] = { name = "N", hl = "Normal" },
        ["v"] = { name = "V", hl = "Visual" },
        ["vs"] = { name = "V", hl = "Visual" },
        ["V"] = { name = "V-LINE", hl = "Visual" },
        ["Vs"] = { name = "V-LINE", hl = "Visual" },
        ["\22"] = { name = "V", hl = "Visual" },
        ["\22s"] = { name = "V", hl = "Visual" },
        ["s"] = { name = "SELECT", hl = "Insert" },
        ["S"] = { name = "S-LINE", hl = "Normal" },
        ["\19"] = { name = "S-BLOCK", hl = "Normal" },
        ["i"] = { name = "I", hl = "Insert" },
        ["ic"] = { name = "I", hl = "Insert" },
        ["ix"] = { name = "I", hl = "Insert" },
        ["R"] = { name = "R", hl = "Replace" },
        ["Rc"] = { name = "R", hl = "Replace" },
        ["Rx"] = { name = "R", hl = "Replace" },
        ["Rv"] = { name = "V-REPLACE", hl = "Replace" },
        ["Rvc"] = { name = "V-REPLACE", hl = "Replace" },
        ["Rvx"] = { name = "V-REPLACE", hl = "Replace" },
        ["c"] = { name = "C", hl = "Command" },
        ["cv"] = { name = "EX", hl = "Command" },
        ["ce"] = { name = "EX", hl = "Command" },
        ["r"] = { name = "R", hl = "Normal" },
        ["rm"] = { name = "MORE", hl = "Normal" },
        ["r?"] = { name = "CONFIRM", hl = "Normal" },
        ["!"] = { name = "SHELL", hl = "Normal" },
        ["t"] = { name = "T", hl = "Command" },
    }

    local mode_name = mode_settings[vim.fn.mode()] or {}
    local m_char = mode_name.name

    local hl_l = "%#SL" .. mode_name.hl .. "Norm#"
    local hl_bg = "%#SLBG#"
    local hl_arrow = "%#SLARROW#"

    local left_arrow = "%#SL" .. mode_name.hl .. "Left#"
    local right_arrow = "%#SL" .. mode_name.hl .. "Right#"

    local ft = (vim.bo.filetype ~= "" and vim.bo.filetype or "none"):lower()
    local fname = vim.fn.expand("%:t") ~= "" and vim.fn.expand("%:t") or "init"
    local extension = vim.fn.fnamemodify(fname, ":e")
    local icon = get_file_icon(fname, extension)
    local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 })
    local lsp_status = (#clients > 0) and "  " or " "

    vim.opt.statusline = table.concat({
        hl_l,
        " ",
        m_char .. " ", -- mode char
        left_arrow,
        "",
        get_git_branch(),
        "  ",
        statusline_diagnostics(),
        hl_arrow,
        "",
        hl_bg,
        marlin_component(),
        "%=", -- Fill rest of bar with vibrant color
        lsp_progress_component(),
        spaces(),
        "  ",
        icon .. " " .. ft .. lsp_status, -- filetype/lsp status
        right_arrow,
        "",
        left_arrow,
        " %3l:%-2c ", -- line/column
    })
end

return M
