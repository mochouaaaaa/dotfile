local flatten = {
    "willothy/flatten.nvim",
    enabled = true,
    lazy = false,
    opts = function()
        ---@type Terminal?
        local saved_terminal

        return {
            callbacks = {
                should_block = function(argv)
                    return vim.tbl_contains(argv, "-b")
                end,
                pre_open = function() -- Close toggleterm when an external open request is received
                    -- require("toggleterm").toggle(0)
                    local term = require("toggleterm.terminal")
                    local termid = term.get_focused_id()
                    saved_terminal = term.get(termid)
                end,
                post_open = function(bufnr, winnr, ft, is_blocking)
                    if is_blocking and saved_terminal then
                        saved_terminal:close()
                    else
                        vim.api.nvim_set_current_win(winnr)
                        require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")))
                    end

                    if ft == "gitcommit" then
                        -- If the file is a git commit, create one-shot autocmd to delete it on write
                        -- If you just want the toggleable terminal integration, ignore this bit and only use the
                        -- code in the else block
                        vim.api.nvim_create_autocmd("BufWritePost", {
                            buffer = bufnr,
                            once = true,
                            callback = function()
                                -- This is a bit of a hack, but if you run bufdelete immediately
                                -- the shell can occasionally freeze
                                vim.defer_fn(function()
                                    vim.api.nvim_buf_delete(bufnr, {})
                                end, 50)
                            end,
                        })
                        return
                    end
                    -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
                    -- This gives the appearance of the window opening independently of the terminal
                    vim.cmd.q()
                    require("toggleterm").toggle(0)
                    vim.api.nvim_set_current_buf(bufnr)
                    vim.api.nvim_set_current_win(winnr)
                end,
                block_end = function()
                    -- After blocking ends (for a git commit, etc), reopen the terminal
                    -- require("toggleterm").toggle(0)
                    vim.schedule(function()
                        if saved_terminal then
                            saved_terminal:open()
                            saved_terminal = nil
                        end
                    end)
                end,
            },
        }
    end,
}

local toggleterm = {
    "akinsho/toggleterm.nvim",
    config = function(_, opts)
        require("toggleterm").setup(opts)
        require("plugins.terminal.lazygit")
        require("plugins.terminal.terminal")
    end,
}

return {
    flatten,
    toggleterm,
}
