local ok, cmp = pcall(require, "cmp")
if not ok then
    vim.notify("Unable to require cmp", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local cmpok, cmplsp = pcall(require, "cmp_nvim_lsp")
if not cmpok then
    vim.notify("Unable to require cmp_nvim_lsp", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local kindok, lspkind = pcall(require, "lspkind")
if not kindok then
    vim.notify("Unable to require lspkind", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local configok, compare = pcall(require, "cmp.config.compare")
if not configok then
    vim.notify("Unable to require cmp.config.compare", vim.lsp.log_levels.ERROR,
               {title = "Plugin error"})
    return
end

local iconok, i = pcall(require, "config.icons")
if not iconok then
    vim.notify("Unable to require config.icons", vim.lsp.log_levels.ERROR,
               {title = "Config error"})
    return
end

local luasnipok, luasnip = pcall(require, "luasnip")
if not luasnipok then
    vim.notify("Unable to require luasnip")
    return
end

local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

cmplsp.setup()

cmp.setup({
    preselect = true,
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            symbol_map = i.symbol_map,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]"
            }
        })
    },
    sorting = {
        priority_weight = 2.,
        comparators = {
            compare.offset, compare.exact, compare.score, compare.kind,
            compare.sort_text, compare.length, compare.order
        }
    },
    min_length = 0, -- allow for `from package import _` in Python
    mapping = {
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), {"i", "c"}),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), {"i", "c"}),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
        ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()
        }),
        ["<C-y>"] = cmp.config.disable,
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<CR>"] = cmp.mapping.confirm({select = true}),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expandable() then
                luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {"i", "s"})
    },
    sources = {
        {name = "nvim_lsp"}, {name = "nvim_lua"}, {name = "path"},
        {name = "luasnip"}, {name = "buffer", keyword_length = 3}
    }
})
