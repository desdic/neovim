local M = {
    "booperlv/nvim-gomove",
    event = "VeryLazy",
    config = {map_defaults = false, reindent = true, undojoin = true, move_past_end_col = false},
    keys = {
        {"<S-j>", "<Plug>GoVSMDown", mode = {"x"}, desc = "Move visual line down"},
        {"<S-k>", "<Plug>GoVSMUp", mode = {"x"}, desc = "Move visual line up"},
        {"<S-h>", "<Plug>GoVSMLeft", mode = {"x"}, desc = "Move visual line left"},
        {"<S-l>", "<Plug>GoVSMRight", mode = {"x"}, desc = "Move visual line right"}
    }
}

return M
