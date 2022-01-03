local ok, neoclip = pcall(require, "neoclip")
if not ok then
    vim.notify("Unable to require neoclip", "error")
    return
end

neoclip.setup()
