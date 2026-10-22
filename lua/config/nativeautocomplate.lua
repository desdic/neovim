-- play with native LSP complation + snippets

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("my.lsp", {}),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end,
})

local snippet_source = {}

local function read_json(path)
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok or not lines or vim.tbl_isempty(lines) then
        return nil
    end
    local ok_decode, data = pcall(vim.json.decode, table.concat(lines, "\n"))
    if not ok_decode then
        return nil
    end
    return data
end

local function normalize_prefix(prefix)
    if type(prefix) == "string" then
        return { prefix }
    elseif type(prefix) == "table" then
        return prefix
    end
    return {}
end

local function normalize_body(body)
    if type(body) == "string" then
        return body
    elseif type(body) == "table" then
        return table.concat(body, "\n")
    end
    return nil
end

local function load_snippets_package(root)
    local pkg = read_json(root .. "/package.json")
    if not pkg or not pkg.contributes or not pkg.contributes.snippets then
        return
    end

    for _, spec in ipairs(pkg.contributes.snippets) do
        local lang = spec.language
        local file = root .. "/" .. spec.path
        local defs = read_json(file)
        if defs then
            snippet_source[lang] = snippet_source[lang] or {}
            for name, def in pairs(defs) do
                local body = normalize_body(def.body)
                if body then
                    table.insert(snippet_source[lang], {
                        name = name,
                        prefixes = normalize_prefix(def.prefix),
                        body = body,
                        description = def.description or name,
                    })
                end
            end
        end
    end
end

load_snippets_package(vim.fn.stdpath("config") .. "/snippets")

local function current_word_start()
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col(".") - 1
    local start = col
    while start > 0 and line:sub(start, start):match("[%w_-]") do
        start = start - 1
    end
    return start
end

function _G.NativeSnippetComplete(findstart, base)
    if findstart == 1 then
        return current_word_start()
    end

    local ft = vim.bo.filetype
    local pool = {}

    if snippet_source.all then
        vim.list_extend(pool, snippet_source.all)
    end
    if snippet_source[ft] then
        vim.list_extend(pool, snippet_source[ft])
    end

    local items = {}
    for _, snip in ipairs(pool) do
        for _, prefix in ipairs(snip.prefixes) do
            if prefix and prefix:lower():find("^" .. vim.pesc(base:lower())) then
                table.insert(items, {
                    word = prefix,
                    abbr = prefix,
                    menu = "[Snippet]",
                    info = snip.description,
                    kind = "s",
                    user_data = vim.json.encode({
                        source = "native-snippet",
                        body = snip.body,
                        prefix = prefix,
                    }),
                })
            end
        end
    end

    return items
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        vim.bo[args.buf].completefunc = "v:lua.NativeSnippetComplete"
    end,
})

vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
        local item = vim.v.completed_item
        if not item or not item.user_data or item.user_data == "" then
            return
        end

        local ok, data = pcall(vim.json.decode, item.user_data)
        if not ok or data.source ~= "native-snippet" or not data.body then
            return
        end

        local prefix = data.prefix or item.word or ""
        if prefix ~= "" then
            local bs = vim.api.nvim_replace_termcodes(string.rep("<BS>", #prefix), true, false, true)
            vim.api.nvim_feedkeys(bs, "n", false)
        end

        vim.schedule(function()
            vim.snippet.expand(data.body)
        end)
    end,
})

vim.o.autocomplete = true
vim.opt.complete:append("F")
vim.opt.complete:append("o")
vim.opt.completeopt = { "menu", "popup", "menuone", "noselect" }
vim.o.pumheight = 10
vim.o.pumborder = "rounded"
vim.o.autocompletedelay = 200
vim.o.autocompletetimeout = 80

vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if vim.snippet.active({ direction = 1 }) then
        return "<Cmd>lua vim.snippet.jump(1)<CR>"
    end
    return "<Tab>"
end, { expr = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if vim.snippet.active({ direction = -1 }) then
        return "<Cmd>lua vim.snippet.jump(-1)<CR>"
    end
    return "<S-Tab>"
end, { expr = true })

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    once = true,
    callback = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        local servers = vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
            :map(function(file)
                return vim.fn.fnamemodify(file, ":t:r")
            end)
            :totable()
        vim.lsp.enable(servers)
    end,
})
