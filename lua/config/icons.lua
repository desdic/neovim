local _icons = {
    bar = {thick = "┃", thin = "│"},
    diag = {
        error = "",
        warn = "",
        -- hint = "➤",
        hint = "",
        info = "",
        pass = "",
        -- virtual = ""
        virtual = "•"
    },
    diff = {add = "", mod = "", del = ""},
    file = {mod = "", lock = ""},
    git = {branch = ""},
    lang = {
        class = "ﴯ",
        color = "",
        constant = "",
        constructor = "",
        enum = "",
        enummember = "",
        event = "",
        field = "",
        file = "",
        folder = "ﱮ",
        ["function"] = "",
        interface = "",
        keyword = "",
        method = "",
        module = "",
        operator = "",
        property = "",
        reference = "",
        snippet = "",
        struct = "פּ",
        text = "",
        typeparameter = "",
        unit = "塞",
        value = "",
        variable = ""
    },
    symbol_map = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "ﴲ",
        Variable = "[]",
        Class = "",
        Interface = "ﰮ",
        Module = "",
        Property = "襁",
        Unit = "",
        Value = "",
        Enum = "練",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "ﲀ",
        Struct = "ﳤ",
        Event = "",
        Operator = "",
        TypeParameter = ""
    }
}

local icons = vim.tbl_extend("force", {}, _icons)
for name, section in pairs(_icons) do
    for k, v in pairs(section) do
        icons[name]["_" .. k] = " " .. v -- leading space
        icons[name][k .. "_"] = v .. " " -- trailing space
        icons[name]["_" .. k .. "_"] = " " .. v .. " " -- both
    end
end

return icons
