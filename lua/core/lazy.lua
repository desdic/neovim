local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "--single-branch", "https://github.com/folke/lazy.nvim.git", lazypath
    })
end
vim.opt.runtimepath:prepend(lazypath)

local lazyok, lazy = pcall(require, "lazy")
if not lazyok then
    vim.notify("Unable to require lazy", vim.lsp.log_levels.ERROR, {title = "Plugin error"})
    return
end

lazy.setup("plugins", {
    defaults = {lazy = true}, -- be lazy
    ui = {border = "rounded"}, -- show borders
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                -- "matchparen",
                "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin"
            }
        }
    },
    dev = {path = "~/src/private", patterns = {}},
    install = {colorscheme = {"catppuccin", "habamax"}}
})
