local function update_git_signs()
    local bufnr = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
        return
    end
    local file_path = vim.api.nvim_buf_get_name(bufnr)
    if file_path == "" then
        return
    end

    -- Define explicit colors for your signs here
    vim.cmd([[
    hi default GitSignsAdd    guifg=#83a598
    hi default GitSignsChange guifg=#fe8019
    hi default GitSignsDelete guifg=#fb4934
  ]])

    if vim.fn.sign_getdefined("GitSignAdd")[1] == nil then
        vim.fn.sign_define("GitSignAdd", { text = "┃", texthl = "GitSignsAdd" })
        vim.fn.sign_define("GitSignChange", { text = "┃", texthl = "GitSignsChange" })
        vim.fn.sign_define("GitSignDelete", { text = "┃", texthl = "GitSignsDelete" })
    end

    vim.fn.sign_unplace("SimpleGitSigns", { buffer = bufnr })

    local cmd = string.format("git diff --no-color --unified=0 -- %s", vim.fn.shellescape(file_path))
    local output = {}

    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(output, line)
                    end
                end
            end
        end,
        on_exit = function(_, exit_code)
            if exit_code ~= 0 and exit_code ~= 1 then
                return
            end

            for _, line in ipairs(output) do
                if vim.startswith(line, "@@") then
                    -- Robustly parse the hunk header format: @@ -old_start[,old_len] +new_start[,new_len] @@
                    local old_info, new_info = line:match("@@ %-(%S+) %+(%S+) @@")

                    if old_info and new_info then
                        -- Split standard "start,len" strings into separate components
                        local old_start, old_len = old_info:match("(%d+),?(%d*)")
                        local new_start, new_len = new_info:match("(%d+),?(%d*)")

                        old_len = tonumber(old_len) or (old_info:find(",") and 0 or 1)
                        new_len = tonumber(new_len) or (new_info:find(",") and 0 or 1)
                        local start_line = tonumber(new_start)

                        local sign_type = "GitSignChange"
                        if new_len == 0 then
                            sign_type = "GitSignDelete"
                            new_len = 1
                        elseif old_len == 0 then
                            sign_type = "GitSignAdd"
                        end

                        for i = 0, new_len - 1 do
                            vim.fn.sign_place(0, "SimpleGitSigns", sign_type, bufnr, {
                                lnum = start_line + i,
                                priority = 10,
                            })
                        end
                    end
                end
            end
        end,
    })
end

-- Automatically trigger the function on buffer events
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("SimpleGitSignsGroup", { clear = true }),
    pattern = "*",
    callback = update_git_signs,
})
