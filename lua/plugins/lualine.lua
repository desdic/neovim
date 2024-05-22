return {
    "nvim-lualine/lualine.nvim",
    dependencies = { { "stevearc/aerial.nvim" }, { "desdic/marlin.nvim" } },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local marlin = require("marlin")
        local lazy_status = require("lazy.status") -- to configure lazy pending updates count

        local hide_in_width = function()
            return vim.fn.winwidth(0) > 80
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

        local opt = { buf = 0 }

        local diff = {
            "diff",
            colored = false,
            symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
            cond = hide_in_width,
        }

        local mode = {
            "mode",
            fmt = function(str)
                return "-- " .. str .. " --"
            end,
        }

        local filetype = {
            function()
                local buf_ft = vim.api.nvim_get_option_value("filetype", opt)
                if buf_ft == "toggleterm" then
                    return ""
                end
                return buf_ft
            end,
            icons_enabled = false,
            icon = nil,
        }

        local branch = { "branch", icons_enabled = true, icon = "" }

        local marlin_component = function()
            local indexes = marlin.num_indexes()
            if indexes == 0 then
                return ""
            end
            local cur_index = marlin.cur_index()

            return "  " .. cur_index .. "/" .. indexes
        end

        local location = { "location", padding = 0 }

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

        local filename = {
            function()
                local buf_ft = vim.api.nvim_get_option_value("filetype", opt)
                if buf_ft == "toggleterm" then
                    return "terminal"
                end

                local filepath = vim.fn.expand("%:p")

                if #filepath > 52 then
                    filepath = ".." .. string.sub(filepath, -50)
                end

                return filepath
            end,
            padding = { right = 1 },
            cond = hide_in_width,
        }

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "catppuccin",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {
                    statusline = { "dashboard", "lazy" },
                    winbar = {
                        "help",
                        "startify",
                        "neogitstatus",
                        "dashboard",
                        "toggleterm",
                        "qf",
                    },
                },
                always_divide_middle = true,
                globalstatus = true,
            },
            sections = {
                lualine_a = { branch, diagnostics },
                lualine_b = { mode },
                lualine_c = { marlin_component, "aerial" },
                lualine_x = {
                    "%=",
                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        color = { fg = "#ff9e64" },
                    },
                    diff,
                    spaces,
                    "encoding",
                    filetype,
                },
                lualine_y = { location },
                lualine_z = {},
            },
            winbar = {
                lualine_c = { "%=", "%m", filename },
            },
            inactive_winbar = {
                lualine_c = { "%=", "%m", filename },
            },
            tabline = {},
            extensions = { "lazy", "aerial", "nvim-dap-ui" },
        })
    end,
}
