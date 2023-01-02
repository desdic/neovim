local M = {"nvim-lualine/lualine.nvim", lazy = false}

function M.config()
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
        return vim.fn.expand("%:.")
    end

    local navicok, navic = pcall(require, "nvim-navic")
    local navicinfo = {
        function()
            if navicok and navic.is_available() then return " " .. navic.get_location() end
            return ""
        end,
        padding = {right = 1},
        cond = hide_in_width
    }

    require("lualine").setup({
        options = {
            icons_enabled = true,
            -- theme = "tokyonight",
            -- theme = custom_catppuccin,
            theme = "catppuccin",
            -- theme = "nightfox",
            component_separators = {left = "", right = ""},
            section_separators = {left = "", right = ""},
            disabled_filetypes = {
                statusline = {"dashboard", "NvimTree", "Outline", "lazy"},
                winbar = {
                    "help", "startify", "dashboard", "packer", "neogitstatus", "NvimTree", "Trouble", "alpha", "lir",
                    "Outline", "spectre_panel", "toggleterm", "qf"
                }
            },
            always_divide_middle = true,
            globalstatus = true
        },
        sections = {
            lualine_a = {branch, diagnostics},
            lualine_b = {mode},
            lualine_c = {navicinfo},
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
        winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {filename}
        },
        inactive_winbar = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {filename}
        },
        tabline = {},
        extensions = {}
    })
end

return M
