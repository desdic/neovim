vim.pack.add({
    { src = "https://github.com/paulbkim-dev/vim-herdr-navigation" },
}, { confirm = false })

vim.g.tmux_navigator_no_mappings = 1

dofile(vim.fn.stdpath("data") .. "/site/pack/core/opt/vim-herdr-navigation/editor/nvim.lua")
