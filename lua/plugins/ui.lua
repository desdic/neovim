return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        opts = function()
            local dashboard = require("alpha.themes.dashboard")
            local logo = [[
                                     .__                  
              ____   ____  _______  _|__| _____           
             /    \_/ __ \/  _ \  \/ /  |/     \          
            |   |  \  ___(  <_> )   /|  |  Y Y  \         
            |___|  /\___  >____/ \_/ |__|__|_|  /         
                 \/     \/                    \/          
        ]]
            dashboard.section.header.val = vim.split(logo, "\n")
            dashboard.section.buttons.val = {
                dashboard.button("c", "  Configuration", ":lua require('custom.telescope').search_nvim()<CR>"),
                dashboard.button("f", "  Find file", ":Telescope find_files <CR>"),
                dashboard.button("g", "  Grep text", ":Telescope live_grep <CR>"),
                dashboard.button("h", "  Harpoon", ":Telescope harpoon marks<CR>"),
                dashboard.button("l", "  Lazy", ":Lazy<CR>"), dashboard.button("m", "  Mason", ":Mason<CR>"),
                dashboard.button("n", "  Notes", ":lua require('custom.telescope').grep_notes()<CR>"),
                dashboard.button("r", "  Recently used files", ":Telescope oldfiles <CR>"),
                dashboard.button("t", "  Update treesitter", ":TSUpdateSync<CR>"),
                dashboard.button("u", "  Update plugins", ":Lazy sync<CR>"),
                dashboard.button("q", "  Quit Neovim", ":qa<CR>")
            }

            dashboard.section.footer.opts.hl = "Type"
            dashboard.section.header.opts.hl = "Include"
            dashboard.section.buttons.opts.hl = "Keyword"

            dashboard.opts.opts.noautocmd = true
            return dashboard
        end,
        config = function(_, dashboard)
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User",
                                            {pattern = "AlphaReady", callback = function()
                    require("lazy").show()
                end})
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    -- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins "
                    pcall(vim.cmd.AlphaRedraw)
                end
            })
        end
    }, {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        config = function()
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
                        statusline = {"alpha", "NvimTree", "Outline", "lazy"},
                        winbar = {
                            "help", "startify", "packer", "neogitstatus", "NvimTree", "Trouble", "alpha", "lir",
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
    }, {
        "rcarriga/nvim-notify",
        lazy = false,
        -- event = "VeryLazy",
        config = function()
            local notify = require("notify")

            notify.setup({
                background_colour = "#000000",
                timeout = 1000,
                level = vim.log.levels.INFO,
                fps = 20,
                max_height = function() return math.floor(vim.o.lines * 0.75) end,
                max_width = function() return math.floor(vim.o.columns * 0.75) end,
                stages = "static"
            })

            vim.notify = notify
        end
    }, {
        "stevearc/dressing.nvim",
        event = "VeryLazy",

        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({plugins = {"dressing.nvim"}})
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({plugins = {"dressing.nvim"}})
                return vim.ui.input(...)
            end
        end
    }, {
        "beauwilliams/focus.nvim",
        opts = {
            enable = true,
            cursorline = false,
            signcolumn = true,
            number = false,
            excluded_filetypes = {"toggleterm"}
        },
        config = function(_, opts) require("focus").setup(opts) end,
        keys = {
            {"<Leader>sl", function() require("focus").split_command("h") end, desc = "[S]plit window [l]eft"},
            {"<Leader>sr", function() require("focus").split_command("l") end, desc = "[S]plit window [r]ight"}
        }
    },
    {"chentoast/marks.nvim", event = "BufEnter", opts = {}, config = function(_, opts) require("marks").setup(opts) end},
    {
        "akinsho/nvim-bufferline.lua",
        event = "VeryLazy",
        keys = {
            {"<S-l>", ":BufferLineCycleNext<CR>", desc = "Move to next buffer"},
            {"<S-h>", ":BufferLineCyclePrev<CR>", desc = "Move to previous buffer"}
        },
        opts = {
            options = {
                show_buffer_close_icons = false,
                show_buffer_icons = false,
                show_close_icon = false,
                persist_buffer_sort = true,
                name_formatter = function(opts) return string.format(" %s ", opts.name) end,
                numbers = function(opts) return string.format(" %s ", opts.ordinal) end
            }
        }
    }
}
