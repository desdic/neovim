local M = {}

-- Search in my notes
function M.grep_notes()
    local tsbuildin = require("telescope.builtin")
    local optsgrep = {}
    optsgrep.search_dirs = { "~/notes/" }
    optsgrep.prompt_prefix = "   "
    optsgrep.prompt_title = "Search Notes"
    tsbuildin.live_grep(optsgrep)
end

-- Search in my neovim config
function M.search_nvim()
    local tsbuildin = require("telescope.builtin")
    tsbuildin.find_files({ prompt_title = "< VimRC >", cwd = "$HOME/.config/nvim/" })
end

return M
