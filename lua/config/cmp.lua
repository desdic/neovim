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

cmplsp.setup()

cmp.setup({
    preselect = false,
    snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
    formatting = {
        fields = {"kind", "abbr", "menu"},
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s", i.symbol_map[vim_item.kind])
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]"
            })[entry.source.name]
            return vim_item
        end
    },
    sorting = {
        priority_weight = 2.,
        comparators = {
            compare.offset, compare.exact, compare.score, compare.kind,
            compare.sort_text, compare.length, compare.order
        }
    },
    min_length = 0, -- allow for `from package import _` in Python
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.config.disable,
        ["<CR>"] = cmp.mapping.confirm({select = false}),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, {"i", "s"})
    }),
    sources = {
        {name = "nvim_lsp"}, {name = "nvim_lua"}, {name = "path"},
        {name = "luasnip"}, {name = "buffer", keyword_length = 3}
    },
    window = {documentation = cmp.config.window.bordered()}
})
