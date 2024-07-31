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

        local trouble = require("trouble")
        local symbols = trouble.statusline({
            mode = "lsp_document_symbols",
            groups = {},
            title = false,
            filter = { range = true },
            format = "{kind_icon}{symbol.name:Normal}",
            -- The following line is needed to fix the background color
            -- Set it to the lualine section you want to use
            hl_group = "lualine_c_normal",
        })

        -- local filename = {
        --     function()
        --         local buf_ft = vim.api.nvim_get_option_value("filetype", opt)
        --         if buf_ft == "toggleterm" then
        --             return " terminal"
        --         end
        --
        --         local filepath = vim.fn.expand("%:t")
        --
        --         if #filepath > 50 then
        --             filepath = ".." .. string.sub(filepath, -48)
        --         end
        --         local modified = ""
        --         local buf_modified = vim.api.nvim_get_option_value("modified", opt)
        --         if buf_modified then
        --             modified = " ●"
        --         end
        --
        --         return " " .. filepath .. modified
        --     end,
        --     padding = { right = 1 },
        --     cond = hide_in_width,
        -- }

        local filepath = {
            function()
                local curfile = vim.fs.dirname(vim.api.nvim_buf_get_name(0))

                local rootdir = vim.fs.dirname(vim.fs.find({ ".git", "go.mod" }, { upward = true })[1])
                if rootdir == nil then
                    return curfile .. "/"
                end

                -- remove last element
                local tmp = {}
                for section in rootdir:gmatch("[^/]+") do
                    table.insert(tmp, section)
                end
                table.remove(tmp, #tmp)

                rootdir = table.concat(tmp, "/")

                local sub = string.gsub(curfile, "/" .. rootdir, "")

                if sub ~= "" then
                    return "~" .. sub .. "/"
                end

                return rootdir
            end,
            cond = hide_in_width,
        }

        -- Prevent winbar to disapear when no symbols are available
        local filler = {
            function()
                return " "
            end,
            padding = { right = 3 },
            separator = "",
            icons_enabled = false,
        }

        return {
            options = {
                icons_enabled = true,
                theme = "catppuccin",
                -- component_separators = { left = "", right = "" },
                -- section_separators = { left = "", right = "" },
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
                lualine_b = { "branch", diagnostics },
                lualine_c = {
                    filepath,
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
                lualine_c = {
                    filler,
                    { symbols.get, cond = symbols.has },
                },
            },
            inactive_winbar = {},
            extensions = { "nvim-dap-ui" },
        }
    end,
}
