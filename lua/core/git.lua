local M = {}

local function splitstr(str)
    local lines = {}
    for sub in str:gmatch("[^\r\n]+") do
        table.insert(lines, sub)
    end
    return lines
end

local function trimspaces(str)
    return str:gsub("%s+", "")
end

local function get_relative_file_path(repo_root)
    local current = trimspaces(vim.api.nvim_buf_get_name(0))
    local s, e = string.find(current, repo_root, 1, true)
    if s ~= 1 then
        print("Repo root is not a prefix")
        return nil
    end
    local removed = current:sub(e + 2)
    return removed
end

local function get_url()
    local branch = trimspaces(vim.fn.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }))
    local path = get_relative_file_path(trimspaces(vim.fn.system({ "git", "rev-parse", "--show-toplevel" })))
    local remote = trimspaces(splitstr(vim.fn.system({ "git", "remote" }))[1])
    local url = trimspaces(vim.fn.system({ "git", "remote", "get-url", remote }))

    url = url:gsub(".*@", ""):gsub("http[s]+://", "")

    local pattern = "([%w%p]+)[:/]([%w%p]+)/([%w%p]+)"
    local base, user, repo = string.match(url, pattern)
    repo = repo:gsub("%.git$", "")

    if string.find(base, "github") then
        url = string.format("https://%s/%s/%s/blob/%s/%s", base, user, repo, branch, path)
    else
        url = string.format("https://%s/%s/%s/-/blob/%s/%s", base, user, repo, branch, path)
    end

    local cursor = vim.api.nvim_win_get_cursor(0)

    return url .. "#L" .. tostring(cursor[1])
end

M.open = function()
    local url = get_url()
    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
end

return M
