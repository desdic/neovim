return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "stevearc/aerial.nvim" },
    event = "VeryLazy",
    config = function()
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
                local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
                if buf_ft == "toggleterm" then
                    return ""
                end
                return buf_ft
            end,
            icons_enabled = false,
            icon = nil,
        }

        local branch = { "branch", icons_enabled = true, icon = "" }

        local location = { "location", padding = 0 }

        local spaces = function()
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            if buf_ft == "toggleterm" then
                return ""
            end
            return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
        end

        local filename = {
            function()
                local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
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
                    statusline = { "alpha", "lazy" },
                    winbar = {
                        "help",
                        "startify",
                        "neogitstatus",
                        "alpha",
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
                lualine_c = { "aerial" },
                lualine_x = { "%=", diff, spaces, "encoding", filetype },
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
            extensions = { "nvim-dap-ui" },
        })
    end,
}
