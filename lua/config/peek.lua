local M = {"toppair/peek.nvim", build = "deno task --quiet build:fast", event = "VeryLazy", config = {}}

function M.init()
    vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
end

return M
