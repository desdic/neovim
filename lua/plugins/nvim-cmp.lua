return {
    "hrsh7th/nvim-cmp",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "onsails/lspkind-nvim",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "lukas-reineke/cmp-under-comparator",
        {
            'windwp/nvim-autopairs',
            opts = {
                check_ts = true,
                disable_filetype = { "TelescopePrompt", "vim" },
                fast_wrap = {},
            }
        },
    },
    config = function()
        local cmp = require("cmp")
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
            min_length = 0,     -- allow for `from package import _` in Python
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),     -- no not select first item
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
                end, { "i", "s" }),
            }),
            sources = {
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "nvim_lua" },
                { name = "path" },
                { name = "nvim_lsp_signature_help" },
            },
            performance = {
                max_view_entries = 50,
            },
            window = { documentation = cmp.config.window.bordered(), completion = cmp.config.window.bordered() },
        })

        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end,
}
