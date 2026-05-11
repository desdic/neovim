local function trim(s)
    return s:match("^%s*(.-)%s*$")
end

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
local hide_in_width = function(fns, size)
    if vim.fn.winwidth(0) > size then
        local func_list = type(fns) == "table" and fns or { fns }

        local results = {}

        for _, fn in ipairs(func_list) do
            if type(fn) == "function" then
                local res = fn()

                if res and res ~= "" then
                    table.insert(results, tostring(res))
                end
            else
                if type(fn) == "string" then
                    table.insert(results, fn)
                end
            end
        end

        return string.format("%s", table.concat(results, " "))
    end

    return ""
end

local function get_file_icon(filename)
    local has_minicons, miniicons = pcall(require, "mini.icons")
    if has_minicons then
        local icon, hl, _ = miniicons.get("file", filename)
        return "%#" .. hl .. "#" .. icon
    end
    return ""
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

    local indents = vim.api.nvim_get_option_value("shiftwidth", opt)
    if indents == 0 then
        indents = vim.api.nvim_get_option_value("tabstop", opt)
    end

    return indent .. ":" .. indents
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

    local branch = "  " .. gs.head .. "  "

    return string.format("%s", branch)
end

local lsp_msg = ""
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(args)
        local data = args.data.params.value
        if data.kind == "end" then
            vim.defer_fn(function()
                lsp_msg = ""
                vim.cmd("redrawstatus!")
            end, 1000)
        else
            local title = data.title or "LSP"
            local percentage = data.percentage and tostring(data.percentage) or ""
            if percentage ~= "" then
                percentage = trim(percentage) .. "%%"
            end
            local msg
            if percentage ~= "" then
                msg = string.format(" 󱥸  %3s %s ", percentage, trim(title))
            else
                msg = string.format(" 󱥸  %s ", trim(title))
            end
            lsp_msg = msg
        end
    end,
})

local function get_lsp_msg()
    return lsp_msg
end

local function get_filename()
    local path = vim.fs.normalize(vim.fn.expand("%:p"))
    local prefix, prefix_path = "", ""

    if vim.startswith(path, "term:/") then
        return "  "
    end

    if vim.startswith(path, "diffview") then
        return path
    end

    if vim.api.nvim_win_get_width(0) < math.floor(vim.o.columns / 3) then
        path = vim.fn.pathshorten(path)
    else
        local special_dirs = {
            DOTFILES = vim.env.XDG_CONFIG_HOME,
            HOME = vim.env.HOME,
            ONE = vim.g.work_projects_dir,
            PERSONAL = vim.g.personal_projects_dir,
        }
        for dir_name, dir_path in pairs(special_dirs) do
            if vim.startswith(path, vim.fs.normalize(dir_path)) and #dir_path > #prefix_path then
                prefix, prefix_path = dir_name, dir_path
            end
        end
        if prefix ~= "" then
            path = path:gsub("^" .. prefix_path, "")
            prefix = string.format(" 󰉋 %s", prefix)
        end
    end

    path = path:gsub("^/", "")
    path = path:gsub("/", "  ")

    return prefix .. " " .. path
end

function _G.simple_statusline()
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
    local icon = get_file_icon(fname)
    local clients = vim.lsp.get_clients and vim.lsp.get_clients({ bufnr = 0 })
    local lsp_status = (#clients > 0) and "  " or " "

    return table.concat({
        hl_l,
        " ",
        m_char .. " ", -- mode char
        left_arrow,
        "",
        get_git_branch(),
        statusline_diagnostics(),
        hl_arrow,
        "",
        hl_bg,
        marlin_component(),
        "%=",
        hide_in_width({ get_lsp_msg() }, 80),
        "%=",
        spaces(),
        "  ",
        icon,
        " ",
        ft,
        hl_bg,
        lsp_status, -- filetype/lsp status
        right_arrow,
        "",
        left_arrow,
        " %3l:%-2c ", -- line/column
    })
end

function _G.simple_winbar()
    return "%=" .. get_filename() .. " %m%r"
end

vim.opt.statusline = "%!v:lua.simple_statusline()"
vim.opt.winbar = "%!v:lua.simple_winbar()"
