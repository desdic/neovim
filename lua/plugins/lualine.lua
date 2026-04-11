vim.pack.add({
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
}, { confirm = false })

vim.defer_fn(function()
    local opt = { buf = 0 }
    local have_marlin, marlin = pcall(require, "marlin")
    local marlin_component = function()
        if not have_marlin then
            return ""
        end
        local indexes = marlin.num_indexes()
        if indexes == 0 then
            return ""
        end
        local cur_index = marlin.cur_index()

        return "  " .. cur_index .. "/" .. indexes
    end

    vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
            local value = ev.data.params.value

            if value.kind ~= "end" and "running" or "success" then
                if value.kind == "end" then
                    vim.defer_fn(function()
                        LSPPROGRESS = ""
                        require("lualine").refresh()
                    end, 3000)
                else
                    local pct = value.percentage or ""
                    LSPPROGRESS = table.concat({
                        "󱥸 ",
                        string.format("%s ", pct),
                        string.format("%s", value.title),
                    })
                    require("lualine").refresh()
                end
            end
        end,
    })

    local lsp_progress_component = function()
        return LSPPROGRESS or ""
    end

    local hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end

    local spaces = function()
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

    local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn" },
        symbols = { error = " ", warn = " " },
        colored = false,
        update_in_insert = false,
        always_visible = true,
    }

    local diff = {
        "diff",
        colored = false,
        symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
        cond = hide_in_width,
    }

    local filename = {
        function()
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
        end,
    }

    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = "catppuccin-nvim",
            component_separators = { left = "", right = "" },
            -- section_separators = { left = "", right = "" },
            disabled_filetypes = {
                statusline = { "dashboard", "lazy" },
                winbar = {
                    "dap-repl",
                    "dapui_breakpoints",
                    "dapui_console",
                    "dapui_scopes",
                    "dapui_stacks",
                    "dapui_watches",
                    "dashboard",
                    "help",
                    "qf",
                    "startify",
                },
            },
            always_divide_middle = true,
            globalstatus = true,
        },
        sections = {
            lualine_b = { "branch", diagnostics, vim.diagnostic.status() },
            lualine_c = {
                marlin_component,
            },
            lualine_x = {
                lsp_progress_component,
                diff,
                spaces,
                "encoding",
                "filetype",
            },
            lualine_y = {},
        },

        winbar = {
            lualine_x = {
                filename,
            },
        },

        inactive_winbar = {
            lualine_x = {
                filename,
            },
        },
        extensions = { "nvim-dap-ui", "oil", "quickfix" },
    })
end, 50)
