-- copilot proxy
local ok, _ = pcall(require, "copilot")
if ok then
    vim.g.copilot_proxy = false
end

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Restore cursor position when opening a file -- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd("BufRead", {
    callback = function(opts)
        vim.api.nvim_create_autocmd("BufWinEnter", {
            once = true,
            buffer = opts.buf,
            callback = function()
                local ft = vim.bo[opts.buf].filetype
                local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
                if
                    not (ft:match("commit") and ft:match("rebase"))
                    and last_known_line > 1
                    and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
                then
                    vim.api.nvim_feedkeys([[g`"]], "nx", false)
                end
            end,
        })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_auto_diag", { clear = true }),
    callback = function(args)
        -- the buffer where the lsp attached
        ---@type number
        local buffer = args.buf

        -- create the autocmd to show diagnostics
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
            buffer = buffer,
            callback = function()
                vim.diagnostic.open_float(nil, { focus = false })
            end,
        })
    end,
})

autocmd("BufEnter", {
    desc = "Quit lazynvim if more than one window is open and only sidebar windows are list",
    group = augroup("auto_quit", { clear = true }),
    callback = function()
        local wins = vim.api.nvim_tabpage_list_wins(0)
        -- Both neo-tree and aerial will auto-quit if there is only a single window left
        if #wins <= 1 then
            return
        end
        local sidebar_fts = { aerial = true, ["neo-tree"] = true }
        for _, winid in ipairs(wins) do
            if vim.api.nvim_win_is_valid(winid) then
                local bufnr = vim.api.nvim_win_get_buf(winid)
                local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
                -- If any visible windows are not sidebars, early return
                if not sidebar_fts[filetype] then
                    return
                -- If the visible window is a sidebar
                else
                    -- only count filetypes once, so remove a found sidebar from the detection
                    sidebar_fts[filetype] = nil
                end
            end
        end
        if #vim.api.nvim_list_tabpages() > 1 then
            vim.cmd.tabclose()
        else
            vim.cmd.qall()
        end
    end,
})

autocmd("BufEnter", {
    desc = "Open Neo-Tree on startup with directory",
    group = augroup("neotree_start", { clear = true }),
    callback = function()
        if package.loaded["neo-tree"] then
            return true
        else
            local stats = (vim.uv or vim.loop).fs_stat(vim.api.nvim_buf_get_name(0)) -- TODO: REMOVE vim.loop WHEN DROPPING SUPPORT FOR Neovim v0.9
            if stats and stats.type == "directory" then
                require("lazy").load({ plugins = { "neo-tree.nvim" } })
                return true
            end
        end
    end,
})

autocmd("TermClose", {
    pattern = "*lazygit*",
    group = augroup("neotree_refresh", { clear = true }),
    desc = "Refresh Neo-Tree sources when closing lazygit",
    callback = function()
        local manager_avail, manager = pcall(require, "neo-tree.sources.manager")
        if manager_avail then
            for _, source in ipairs({ "filesystem", "git_status", "document_symbols" }) do
                local module = "neo-tree.sources." .. source
                if package.loaded[module] then
                    manager.refresh(require(module).name)
                end
            end
        end
    end,
})

autocmd("TermClose", {
    pattern = "*lazygit",
    callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
        end
    end,
})
