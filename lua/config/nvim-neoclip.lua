local ok, neoclip = pcall(require, "neoclip")
if not ok then
    vim.notify("Unable to require neoclip")
    return
end

neoclip.setup()
