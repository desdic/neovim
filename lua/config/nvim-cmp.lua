local M = {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-nvim-lua", "hrsh7th/cmp-path", "hrsh7th/cmp-path",
        "onsails/lspkind-nvim", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip"
    }
}

M.config = function()
    local cmp = require("cmp")
    local cmplsp = require("cmp_nvim_lsp")
    local compare = require("cmp.config.compare")
    local lspkind = require("lspkind")
    local luasnip = require("luasnip")

    cmplsp.setup()

    cmp.setup({
        preselect = false,
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        formatting = { format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }) },
        sorting = {
            priority_weight = 1.0,
            comparators = {
                compare.scopes, compare.offset, compare.exact, compare.score, compare.recently_used, compare.locality,
                compare.kind, compare.sort_text, compare.length, compare.order
            }
        },
        min_length = 0, -- allow for `from package import _` in Python
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-y>"] = cmp.config.disable,
            ["<CR>"] = cmp.mapping.confirm({ select = false }),

            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { "i", "s" })
        }),
        sources = {
            { name = "nvim_lsp", priority = 10, keyword_length = 2 }, { name = "buffer", priority = 8, keyword_length = 2 },
            { name = "luasnip", priority = 6, keyword_length = 2 },
            { name = "nvim_lua", priority_weight = 4, keyword_length = 2 },
            { name = "path", priority = 2, keyword_length = 2 }
        },
        window = { documentation = cmp.config.window.bordered(), completion = cmp.config.window.bordered() }
    })
end

return M
