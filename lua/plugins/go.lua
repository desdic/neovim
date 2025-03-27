return {
    "ray-x/go.nvim",
    ft = { "go", "gomod" },
    dependencies = { "ray-x/guihua.lua", "nvim-treesitter/nvim-treesitter" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
        dap_debug = true,
        dap_debug_gui = true,
        lsp_inlay_hints = { enable = false },
        diagnostic = false,
    },
    config = function(_, opts)
        require("go").setup(opts)
    end,
}
