local ok, stabilize = pcall(require, "stabilize")
if not ok then
    vim.notify("Unable to require stabilize")
    return
end

stabilize.setup()
