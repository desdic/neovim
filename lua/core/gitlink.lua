local function open_git_in_browser_at_line()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("No file in current buffer", vim.log.levels.ERROR)
        return
    end

    local line = vim.api.nvim_win_get_cursor(0)[1]

    local function system(cmd)
        local result = vim.fn.systemlist(cmd)
        if vim.v.shell_error ~= 0 then
            return nil
        end
        return result[1]
    end

    local repo_root = system({ "git", "-C", vim.fn.fnamemodify(file, ":h"), "rev-parse", "--show-toplevel" })
    if not repo_root then
        vim.notify("Not inside a git repository", vim.log.levels.ERROR)
        return
    end

    local remote = system({ "git", "-C", repo_root, "remote", "get-url", "origin" })
    if not remote then
        vim.notify("Could not get git remote", vim.log.levels.ERROR)
        return
    end

    local ref = system({ "git", "-C", repo_root, "symbolic-ref", "--short", "HEAD" })
    if not ref then
        ref = system({ "git", "-C", repo_root, "rev-parse", "HEAD" })
    end

    if not ref then
        vim.notify("Could not determine branch or commit", vim.log.levels.ERROR)
        return
    end

    local relpath = file:sub(#repo_root + 2)

    local base_url

    local host, path = remote:match("^git@([^:]+):(.+)%.git$")
    if host and path then
        base_url = "https://" .. host .. "/" .. path
    end

    if not base_url then
        local host2, path2 = remote:match("^ssh://git@([^/]+)/(.+)%.git$")
        if host2 and path2 then
            base_url = "https://" .. host2 .. "/" .. path2
        end
    end

    if not base_url then
        base_url = remote:gsub("%.git$", "")
    end

    if not base_url:match("^https?://") then
        vim.notify("Unsupported remote URL: " .. remote, vim.log.levels.ERROR)
        return
    end

    local url
    if base_url:match("gitlab") then
        url = string.format("%s/-/blob/%s/%s#L%d", base_url, ref, relpath, line)
    else
        url = string.format("%s/blob/%s/%s#L%d", base_url, ref, relpath, line)
    end

    local open_cmd
    if vim.fn.has("mac") == 1 then
        open_cmd = { "open", url }
    elseif vim.fn.has("unix") == 1 then
        open_cmd = { "xdg-open", url }
    elseif vim.fn.has("win32") == 1 then
        open_cmd = { "cmd", "/c", "start", url }
    else
        vim.notify("Unsupported OS", vim.log.levels.ERROR)
        return
    end

    vim.fn.jobstart(open_cmd, { detach = true })
end

vim.api.nvim_create_user_command("OpenGitRemoteLine", open_git_in_browser_at_line, {})

vim.keymap.set("n", "<leader>go", "<cmd>OpenGitRemoteLine<CR>", { desc = "Open line in browser" })
