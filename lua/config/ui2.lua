-- try new ui2

local ui2 = require("vim._core.ui2")
local msgs = require("vim._core.ui2.messages")

-- ── Config ──────────────────────────────────────────────────────────

local IGNORED_KINDS = {
    bufwrite = true,
    [""] = true,
    empty = true,
}

local SKIP_PATTERNS = {
    "%d+L, %d+B",
    "; after #%d+",
    "; before #%d+",
    "%d fewer lines",
    "%d more lines",
    "%d lines yanked",
}

local KIND_TITLES = {
    emsg = { "  Error", "ErrorMsg" },
    echoerr = { "  Error", "ErrorMsg" },
    lua_error = { "  Error", "ErrorMsg" },
    rpc_error = { "  Error", "ErrorMsg" },
    wmsg = { "  Warning", "WarningMsg" },
    echo = { "  Info", "Normal" },
    echomsg = { "  Info", "Normal" },
    lua_print = { "  Print", "Normal" },
    search_cmd = { "  Search", "Normal" },
    search_count = { "  Search", "Normal" },
    undo = { "  Undo", "Normal" },
    shell_out = { "  Shell", "Normal" },
    shell_err = { "  Shell", "ErrorMsg" },
    shell_cmd = { "  Shell", "Normal" },
    quickfix = { "  Quickfix", "Normal" },
    progress = { "  Progress", "Normal" },
    typed_cmd = { "  Command", "Normal" },
    list_cmd = { "  List", "Normal" },
    verbose = { "  Verbose", "Comment" },
}

-- ── State ────────────────────────────────────────────────────────────

local last_title = nil
local last_hl = "Normal"

-- ── Helpers ─────────────────────────────────────────────────────────

local function content_to_text(content)
    if type(content) ~= "table" then
        return tostring(content or "")
    end
    local parts = {}
    for _, chunk in ipairs(content) do
        if type(chunk) == "table" and chunk[2] then
            parts[#parts + 1] = chunk[2]
        end
    end
    return table.concat(parts)
end

local function should_skip(kind, content)
    if IGNORED_KINDS[kind] then
        return true
    end
    local text = content_to_text(content)
    for _, pat in ipairs(SKIP_PATTERNS) do
        if text:find(pat) then
            return true
        end
    end
    return false
end

local function resolve_title(kind, content)
    local entry = KIND_TITLES[kind]
    if entry then
        return entry[1], entry[2]
    end
    local text = vim.trim(content_to_text(content)):gsub("\n.*", "")
    if #text > 40 then
        text = text:sub(1, 37) .. "…"
    end
    return text ~= "" and (" " .. text .. " ") or "  Message ", "Normal"
end

local function override_msg_win()
    local win = ui2.wins and ui2.wins.msg
    if not (win and vim.api.nvim_win_is_valid(win)) then
        return
    end
    if vim.api.nvim_win_get_config(win).hide then
        return
    end
    pcall(vim.api.nvim_win_set_config, win, {
        relative = "editor",
        anchor = "NE",
        row = 1,
        col = vim.o.columns - 1,
        border = "rounded",
        style = "minimal",
        title = last_title and { { last_title, last_hl } } or nil,
        title_pos = last_title and "center" or nil,
    })
end

local function override_pager_win()
    local win = ui2.wins and ui2.wins.pager
    if not (win and vim.api.nvim_win_is_valid(win)) then
        return
    end
    if vim.api.nvim_win_get_config(win).hide then
        return
    end
    local height = vim.api.nvim_win_get_height(win)
    pcall(vim.api.nvim_win_set_config, win, {
        border = "rounded",
        height = height,
        style = "minimal",
        title = last_title and { { last_title, last_hl } } or nil,
        title_pos = last_title and "center" or nil,
    })
end

local function override_dialog_win()
    local win = ui2.wins and ui2.wins.dialog
    if not (win and vim.api.nvim_win_is_valid(win)) then
        return
    end
    if vim.api.nvim_win_get_config(win).hide then
        return
    end
    local height = vim.api.nvim_win_get_height(win)
    pcall(vim.api.nvim_win_set_config, win, {
        border = "rounded",
        height = height,
        style = "minimal",
        title = last_title and { { last_title, last_hl } } or nil,
        title_pos = last_title and "center" or nil,
    })
end

-- ── ui2 enable ──────────────────────────────────────────────────────

ui2.enable({
    enable = true,
    msg = {
        targets = {
            -- "cmd" → command line (floating input area)
            -- "msg" → small message area (like notifications)
            -- "pager" → larger scrollable window (like :messages or errors)

            [""] = "msg",
            empty = "msg",
            bufwrite = "msg",
            echo = "msg",
            echomsg = "msg",
            shell_ret = "msg",
            undo = "msg",
            wmsg = "msg",
            completion = "msg",
            confirm = "dialog",
            confirm_sub = "dialog",
            echoerr = "msg",
            emsg = "msg",
            list_cmd = "pager",
            lua_error = "msg",
            lua_print = "msg",
            progress = "msg",
            quickfix = "msg",
            rpc_error = "msg",
            search_cmd = "cmd",
            search_count = "msg",
            shell_cmd = "cmd",
            shell_err = "cmd",
            shell_out = "cmd",
            typed_cmd = "msg",
            verbose = "pager",
            wildlist = "msg",
        },
        cmd = { height = 0.5 },
        dialog = { height = 0.5 },
        msg = { height = 0.5, timeout = 2000 },
        pager = { height = 0.8 },
    },
})

-- ── Wrap set_pos: the single source of truth for msg window placement ─

local orig_set_pos = msgs.set_pos

msgs.set_pos = function(tgt)
    orig_set_pos(tgt)
    if tgt == "msg" or tgt == nil then
        override_msg_win()
        return
    end
    if tgt == "pager" then
        override_pager_win()
        return
    end

    if tgt == "dialog" then
        override_dialog_win()
    end
end

-- ── Wrap msg_show: filtering + title tracking ─────────────────────────

-- local orig_msg_show = msgs.msg_show

msgs.msg_show = function(kind, content, replace_last, history, append, id, trigger)
    if should_skip(kind, content) then
        return
    end
    local title, hl = resolve_title(kind, content)
    last_title, last_hl = title, hl
    -- orig_msg_show(kind, content, replace_last, history, append, id, trigger)

    local tgt = ui2.cfg.msg.targets[kind]
        or (trigger ~= "" and ui2.cfg.msg.targets[trigger])
        or ui2.cfg.msg.targets[trigger]
        or ui2.cfg.msg.target

    msgs.show_msg(tgt, kind, content, replace_last, append, id)
    msgs.set_pos(tgt)
end

local orig_show_msg = msgs.show_msg
msgs.show_msg = function(tgt, kind, content, replace_last, append, id)
    -- local debug_chunk = { 0, ('[%s:%s] '):format(tgt, kind), 0 }
    -- local debug_content = { debug_chunk }
    -- for _, chunk in ipairs(content) do
    --     debug_content[#debug_content + 1] = chunk
    -- end
    if tgt == "msg" then
        local text = content_to_text(content)
        local width = 0
        for _, line in ipairs(vim.split(text, "\n")) do
            width = math.max(width, vim.api.nvim_strwidth(line))
        end
        local lines = #vim.split(text, "\n")
        if width > math.floor(vim.o.columns * 0.75) or lines > 20 then
            vim.schedule(function()
                -- msgs.show_msg('pager', kind, debug_content, replace_last, append, id)
                msgs.show_msg("pager", kind, content, replace_last, append, id)
                msgs.set_pos("pager")
            end)
            return
        end
    end
    -- orig_show_msg(tgt, kind, debug_content, replace_last, append, id)
    orig_show_msg(tgt, kind, content, replace_last, append, id)
end

-- ── LSP progress ─────────────────────────────────────────────────────

local id = { LspProgressMessages = vim.api.nvim_create_augroup("LspProgressMessages", { clear = true }) }

vim.api.nvim_create_autocmd("LspProgress", {
    group = id.LspProgressMessages,
    callback = function(ev)
        local value = ev.data.params.value
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end
        local is_end = value.kind == "end"
        local msg = value.message and (client.name .. ": " .. value.message)
            or (client.name .. (is_end and ": done" or ""))
        vim.api.nvim_echo({ { msg } }, false, {
            id = "lsp." .. ev.data.client_id,
            kind = "progress",
            source = "vim.lsp",
            title = value.title,
            status = is_end and "success" or "running",
            percent = value.percentage,
        })
    end,
})
