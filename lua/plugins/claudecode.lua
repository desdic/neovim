vim.defer_fn(function()
    vim.pack.add({
        { src = "https://github.com/coder/claudecode.nvim" },
    }, { confirm = false })

    local claude = require("claudecode")
    claude.setup({})

    vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
    vim.keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
    vim.keymap.set("n", "<leader>cr", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
    vim.keymap.set("n", "<leader>cC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
    vim.keymap.set("n", "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
    vim.keymap.set("n", "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer to Calude" })
    vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
    vim.keymap.set("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff in Claude" })
    vim.keymap.set("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff in Claude" })
end, 500)
