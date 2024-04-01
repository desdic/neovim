return {
    "hrsh7th/nvim-cmp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "f3fora/cmp-spell",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "onsails/lspkind-nvim",
        "saadparwaiz1/cmp_luasnip",
        "lukas-reineke/cmp-under-comparator",
    },
    config = function()
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

        local cmplsp = require("cmp_nvim_lsp")
        local compare = require("cmp.config.compare")
        local lspkind = require("lspkind")
        local luasnip = require("luasnip")

        cmplsp.setup()

        cmp.setup({
            preselect = false,
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            formatting = { format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }) },
            sorting = {
                priority_weight = 1.0,
                comparators = {
                    compare.offset,
                    compare.exact,
                    compare.score,
                    compare.recently_used,
                    require("cmp-under-comparator").under,
                    compare.kind,
                },
            },
            min_length = 0, -- allow for `from package import _` in Python
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }), -- no not select first item
                ["<C-e>"] = cmp.mapping.abort(),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = {
                { name = "luasnip", max_item_count = 5 },
                { name = "nvim_lsp", max_item_count = 5 },
                { name = "buffer", max_item_count = 5 },
                { name = "nvim_lua", max_item_count = 5 },
                { name = "path", max_item_count = 5 },
                { name = "nvim_lsp_signature_help", max_item_count = 5 },
                {
                    name = "spell",
                    max_item_count = 5,
                    keyword_length = 5,
                    option = {
                        keep_all_entries = false,
                        enable_in_context = function()
                            return true
                        end,
                    },
                },
            },
            performance = {
                max_view_entries = 20,
            },
            window = { documentation = cmp.config.window.bordered(), completion = cmp.config.window.bordered() },
        })

        -- `:` cmdline setup.
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
            matching = { disallow_symbol_nonprefix_matching = false },
        })

    end,
}
