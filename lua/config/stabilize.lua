local ok, stabilize = pcall(require, "stabilize")
if not ok then
    vim.notify("Unable to require stabilize", "error")
    return
end

stabilize.setup()
