local ok, bufferline = pcall(require, "bufferline")
if not ok then
    vim.notify("Unable to require bufferline")
    return
end

bufferline.setup({})
