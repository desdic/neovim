vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
}, { confirm = false })

local function natural_compare(a, b)
    local function chunk_string(s)
        local chunks = {}
        for text, num in string.gmatch(s, "([^0-9]*)([0-9]*)") do
            if text ~= "" then
                table.insert(chunks, text)
            end
            if num ~= "" then
                table.insert(chunks, tonumber(num))
            end
        end
        return chunks
    end

    local a_chunks = chunk_string(a.text or "")
    local b_chunks = chunk_string(b.text or "")

    for i = 1, math.min(#a_chunks, #b_chunks) do
        local ac, bc = a_chunks[i], b_chunks[i]
        if type(ac) ~= type(bc) then
            return type(ac) == "number" -- Numbers take precedence over text, or vice versa
        elseif ac ~= bc then
            return ac < bc
        end
    end
    return #a_chunks < #b_chunks
end

require("snacks").setup({
    input = { enabled = true, relative = "cursor", row = -3, col = 0 },
    notifier = { enabled = false },
    lazygit = { enabled = true },
    picker = {
        enabled = true,
        formatters = {
            file = {
                truncate = 120,
            },
        },

        layout = {
            layout = {
                min_width = 180,
            },
        },
        sort = function(a, b)
            if a.score ~= b.score then
                return a.score > b.score
            end
            return natural_compare(a, b)
        end,
    },
    bigfile = { enabled = true },
    statuscolumn = { enabled = false },
    quickfile = { enabled = true },
    indent = {
        enabled = false, -- disables listchars
        animate = { enabled = false },
        scope = { enabled = false },
    },
    image = {
        enabled = false,
    },
})

vim.keymap.set("n", "<leader>ff", function()
    require("snacks").picker.files({
        hidden = true,
        cwd = vim.fs.dirname(vim.fs.find({ ".git", "go.mod" }, { upward = true })[1]),
        exclude = { ".zig-cache", "vendor", ".cache" },
    })
end, { desc = "[F]ind [f]iles" })

vim.keymap.set("n", "<leader>lg", function()
    require("snacks").lazygit()
end, { desc = "[L]azy[G]it" })

vim.keymap.set("n", "<leader>fg", function()
    require("snacks").picker.grep({ exclude = { "vendor", ".cache" } })
end, { desc = "[F]ile [g]rep" })

vim.keymap.set("x", "<leader>fg", function()
    require("snacks").picker.grep_word({ exclude = { "vendor", ".cache" } })
end, { desc = "[F]ile [g]rep visual word" })

vim.keymap.set("n", "<leader>fn", function()
    require("snacks").picker.grep({ dirs = { "~/notes" } })
end, { desc = "[F]uzzy [N]otes search" })

vim.keymap.set("n", "<leader>fh", function()
    require("snacks").picker.help()
end, { desc = "[F]uzzy [H]elp tags" })

vim.keymap.set("n", "<leader>,", function()
    require("snacks").picker.buffers()
end, { desc = "Buffer" })

vim.keymap.set("n", "<leader>fv", function()
    require("snacks").picker.grep({ dirs = { "~/.config/nvim" } })
end, { desc = "[Fuzzy] [V]im config" })

vim.keymap.set("n", "z=", function()
    require("snacks").picker.spelling()
end, { desc = "Spell suggest" })

vim.keymap.set("n", "<leader>gn", function()
    require("snacks").picker.notifications()
end, { desc = "Notifications" })

vim.keymap.set("n", "<leader>sd", function()
    require("snacks").picker.diagnostics()
end, { desc = "Diagnostics" })

vim.keymap.set({ "n", "t" }, "<leader>tt", function()
    require("snacks").terminal()
end, { desc = "Toggle term" })

vim.keymap.set("n", "<leader>gb", function()
    require("snacks").git.blame_line()
end, { desc = "[G]it [b]lame line" })

vim.keymap.set("n", "<leader>bd", function()
    require("snacks").bufdelete()
end, { desc = "[D]elete [b]buffer without disrupting window layout" })

vim.keymap.set("n", "<leader><space>", function()
    require("snacks").picker.smart()
end, { desc = "Snacks smart picker" })

vim.keymap.set("n", "<leader>sR", function()
    require("snacks").picker.resume()
end, { desc = "Snacks resume" })
