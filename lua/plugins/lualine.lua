return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "desdic/marlin.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    init = function()
        vim.g.lualine_laststatus = vim.o.laststatus
        if vim.fn.argc(-1) > 0 then
            -- set an empty statusline till lualine loads
            vim.o.statusline = " "
        else
            -- hide the statusline on the starter page
            vim.o.laststatus = 0
        end
    end,
    opts = function()
        local opt = { buf = 0 }
        local marlin = require("marlin")
        local marlin_component = function()
            local indexes = marlin.num_indexes()
            if indexes == 0 then
                return ""
            end
            local cur_index = marlin.cur_index()

            return "  " .. cur_index .. "/" .. indexes
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
            -- padding = { right = 1 },
            -- cond = hide_in_width,
        }

        return {
            options = {
                icons_enabled = true,
                theme = "catppuccin",
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
                        "neogitstatus",
                        "qf",
                        "startify",
                        "toggleterm",
                    },
                },
                always_divide_middle = true,
                globalstatus = true,
            },
            sections = {
                lualine_b = { "branch", diagnostics },
                lualine_c = {
                    -- filename,
                    marlin_component,
                },
                lualine_x = {
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
            extensions = { "nvim-dap-ui" },
        }
    end,
}
