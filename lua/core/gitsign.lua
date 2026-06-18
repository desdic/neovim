local trim = require("core.utils").trim

local function update_git_signs()
    local bufnr = vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
        return
    end

    local file_path = vim.api.nvim_buf_get_name(bufnr)
    if file_path == "" or vim.startswith(file_path, "oil://") or vim.startswith(file_path, "term://") then
        return
    end

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
                    local old_info, new_info = line:match("@@ %-(%S+) %+(%S+) @@")

                    if old_info and new_info then
                        local _, old_len = old_info:match("(%d+),?(%d*)")
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
                                signtype = sign_type,
                            })
                        end
                    end
                end
            end
        end,
    })
end

local function update_git_branch()
    local bufnr = vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
        return
    end

    local file_dir = vim.fn.expand("%:p:h")
    if file_dir == "" or vim.startswith(file_dir, "term://") then
        return
    end

    -- Clean up Oil prefix protocols so git job is run inside a normal OS path string
    if vim.startswith(file_dir, "oil://") then
        file_dir = file_dir:gsub("^oil://", "")
    end

    -- If cleaning up left it unresolvable or missing, default fallback context to shell root context
    if not vim.fn.isdirectory(file_dir) or file_dir == "" then
        return
    end

    vim.fn.jobstart("git branch --show-current", {
        cwd = file_dir,
        stdout_buffered = true,
        on_stdout = function(_, data)
            if not vim.api.nvim_buf_is_valid(bufnr) then
                return
            end

            if data and data[1] and data[1] ~= "" then
                vim.b[bufnr].git_branch = trim(data[1])
            else
                vim.b[bufnr].git_branch = ""
            end
        end,
        on_exit = function(_, code)
            if code ~= 0 then
                vim.b[bufnr].git_branch = ""
            end
            vim.cmd("redrawstatus!")
        end,
    })
end

local simple_git_group = vim.api.nvim_create_augroup("SimpleGitSignsGroup", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave", "FocusGained" }, {
    group = simple_git_group,
    pattern = "*",
    callback = function()
        update_git_signs()
        update_git_branch()
    end,
})

local timer = vim.uv.new_timer()

timer:start(
    1000,
    5000,
    vim.schedule_wrap(function()
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end

        if vim.bo[bufnr].buftype == "" then
            update_git_signs()
            update_git_branch()
        end
    end)
)

vim.api.nvim_create_autocmd("VimLeavePre", {
    group = simple_git_group,
    pattern = "*",
    callback = function()
        if timer and not timer:is_closing() then
            timer:stop()
            timer:close()
        end
    end,
})
