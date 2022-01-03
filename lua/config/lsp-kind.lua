local ok, lspkind = pcall(require, "lspkind")
if not ok then
    vim.notify("Unable to require lspkind", "error")
    return
end

local iconsok, i = pcall(require, "config.icons", "error")
if not iconsok then
    vim.notify("Unable to require config.icons", "error")
    return
end

lspkind.init({
    symbol_map = {
        Class = i.lang.class,
        Color = i.lang.color,
        Constant = i.lang.constant,
        Constructor = i.lang.constructor,
        Enum = i.lang.enum,
        EnumMember = i.lang.enummember,
        Event = i.lang.event,
        Field = i.lang.field,
        File = i.lang.file,
        Folder = i.lang.folder,
        Function = i.lang["function"],
        Interface = i.lang.interface,
        Keyword = i.lang.keyword,
        Method = i.lang.method,
        Module = i.lang.module,
        Operator = i.lang.operator,
        Property = i.lang.property,
        Reference = i.lang.reference,
        Snippet = i.lang.snippet,
        Struct = i.lang.struct,
        Text = i.lang.text,
        TypeParameter = i.lang.typeparameter,
        Unit = i.lang.unit,
        Value = i.lang.value,
        Variable = i.lang.variable
    }
})
