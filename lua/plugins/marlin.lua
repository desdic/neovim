vim.pack.add({
    { src = "https://github.com/desdic/marlin.nvim" },
}, { confirm = false })

local marlin = require("marlin")
marlin.setup({
    open_callback = require("marlin.callbacks").use_split,
    patterns = { ".git", "Makefile", "Cargo.toml", "." },
})

local keymap = vim.keymap.set

keymap("n", "<leader>0", function()
    require("marlin").open_all()
end, { desc = "open all" })

keymap("n", "<leader>fa", function()
    marlin.add()
end, { desc = "add file" })
keymap("n", "<leader>fd", function()
    marlin.remove()
    require("snacks").bufdelete()
end, { desc = "remove file" })
keymap("n", "<leader>f]", function()
    marlin.move_up()
end, { desc = "move up" })
keymap("n", "<leader>f[", function()
    marlin.move_down()
end, { desc = "move down" })
keymap("n", "<leader>fs", function()
    marlin.sort()
end, { desc = "sort" })
keymap("n", "<leader>z", function()
    marlin.toggle()
end, { desc = "toggle" })

keymap("n", "<leader>fx", function()
    local snacks = require("snacks")
    local lookup = {}

    local function get_choices()
        local results = require("marlin").get_indexes()

        local items = {}
        lookup = {}
        for idx, b in ipairs(results) do
            local text = b.filename .. ":" .. b.row

            table.insert(items, {
                formatted = text,
                file = b.filename,
                text = text,
                idx = idx,
                pos = { tonumber(b.row), 0 },
            })

            lookup[text] = b
        end
        return items
    end

    snacks.picker.pick({
        source = "select",
        finder = get_choices,
        title = "Marlin",
        layout = { preview = true },
        actions = {
            marlin_up = function(picker, item)
                require("marlin").move_up(lookup[item.text].filename)
                picker:find({ refresh = true })
            end,
            marlin_down = function(picker, item)
                require("marlin").move_down(lookup[item.text].filename)
                picker:find({ refresh = true })
            end,
            marlin_delete = function(picker, item)
                require("marlin").remove(lookup[item.text].filename)
                picker:find({ refresh = true })
            end,
        },
        win = {
            input = {
                keys = {
                    ["<C-k>"] = { "marlin_up", mode = { "n", "i" }, desc = "Move marlin up" },
                    ["<C-j>"] = { "marlin_down", mode = { "n", "i" }, desc = "Move marlin down" },
                    ["<C-d>"] = { "marlin_delete", mode = { "n", "i" }, desc = "Marlin delete" },
                },
            },
        },
    })
end, { desc = "marlin" })

for index = 1, 4 do
    keymap("n", "<leader>" .. index, function()
        marlin.open(index, { use_split = true })
    end, { desc = "goto " .. index })
end

-- local is_lazy_open = function()
--     local buffers = vim.api.nvim_list_bufs()
--     for _, buf in ipairs(buffers) do
--         local filetype = vim.bo[buf].filetype
--
--         if filetype == "lazy" then
--             return true
--         end
--         if filetype == "lazy_backdrop" then
--             return true
--         end
--     end
--     return false
-- end

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("restore_marlin", { clear = true }),
    callback = function()
        if next(vim.fn.argv()) ~= nil then
            return
        end
        -- if not is_lazy_open() then
        require("marlin").open_all()
        -- end
    end,
    nested = true,
})
