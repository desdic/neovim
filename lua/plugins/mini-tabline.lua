return {
    "echasnovski/mini.tabline",
    -- event = "VeryLazy",
    event = "BufRead",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        format = function(buf_id, label)
            local suffix = vim.bo[buf_id].modified and "+" or ""
            return require("mini.tabline").default_format(buf_id, label) .. suffix
        end,
        tabpage_section = "right",
    },
    keys = {
        { "<S-l>", "<cmd>bnext<CR>", desc = "Move to next buffer" },
        { "<S-h>", "<cmd>bprev<CR>", desc = "Move to previous buffer" },
    },
}
