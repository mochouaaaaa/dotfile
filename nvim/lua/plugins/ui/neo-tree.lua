local M = {
    "nvim-neo-tree/neo-tree.nvim",
    cond = not vim.g.vscode,
    cmd = "Neotree",
    init = function()
        vim.g.neo_tree_remove_legacy_commands = true
    end,
}

local function init_keys()
    local wk = require("which-key")
    wk.register({
        ["<leader>e"] = {
            name = "neo-tree",
            b = { "<Cmd>Neotree buffers<CR>", "Neo-tree Buffers" },
            g = { "<Cmd>Neotree git_status<CR>", "Neo-tree Git Status" },
            d = {
                "<Cmd>Neotree reveal_force_cwd dir=%:h toggle<CR>",
                "Toggle File Explorer in buffer dir",
            },
        },
    })
end

local utils = require("config.utils")

function M.opts()
    vim.g.neo_tree_remove_legacy_commands = 1
    -- mac system cmd keymap
    vim.api.nvim_set_keymap("n", utils.platform_key("cmd") .. "-e>", "<Cmd>Neotree toggle<CR>", {})
    init_keys()

    return {
        auto_clean_after_session_restore = true,
        close_if_last_window = true,
        popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
        sort_case_insensitive = true, -- used when sorting files and directories in the tree
        sort_function = function(a, b)
            if a.type == b.type then
                return a.path < b.path
            else
                return a.type < b.type
            end
        end,
        use_popups_for_input = false, -- If false, inputs will use vim.ui.input() instead of custom floats.
        use_default_mappings = false,
        window = {
            position = "left", -- left, right, top, bottom, float, current
            width = 40, -- applies to left and right positions
            height = 15, -- applies to top and bottom positions
            auto_expand_width = false, -- expand the window when file exceeds the window width. does not work with position = "float"
            popup = {
                -- settings that apply to float position only
                size = {
                    height = "80%",
                    width = "50%",
                },
                position = "50%", -- 50% means center it
                -- you can also specify border here, if you want a different setting from
                -- the global popup_border_style.
            },
            same_level = false, -- Create and paste/move files/directories on the same level as the directory under cursor (as opposed to within the directory under cursor).
            insert_as = "child", -- Affects how nodes get inserted into the tree during creation/pasting/moving of files if the node under the cursor is a directory:
            mapping_options = {
                noremap = true,
                nowait = true,
            },
            mappings = {
                ["<space>"] = "none",
                ["<cr>"] = "open",
                ["<tab>"] = "open",
                ["<esc>"] = "revert_preview",
                ["a"] = {
                    "add",
                    -- some commands may take optional config options, see `:h neo-tree-mappings` for details
                    config = {
                        show_path = "none", -- "none", "relative", "absolute"
                    },
                },
                ["c"] = function(state)
                    local path = state.tree:get_node().path
                    if string.find(path, state.path, 1, true) == 1 then
                        path = string.sub(path, #state.path + 2)
                    end
                    vim.fn.system("echo -n " .. string.format("%q", path) .. " | pbcopy")
                end,
                ["C"] = function(state)
                    local path = state.tree:get_node().path
                    vim.fn.system("echo -n " .. string.format("%q", path) .. " | pbcopy")
                end,
                ["d"] = "delete",
                ["r"] = "rename",
                ["R"] = "refresh",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["z"] = "close_all_nodes",
                ["Z"] = "expand_all_nodes",
                ["q"] = "close_window",
                ["?"] = "show_help",
            },
        },

        filesystem = {
            commands = {
                parent_or_close = function(state)
                    local node = state.tree:get_node()
                    if (node.type == "directory" or node:has_children()) and node:is_expanded() then
                        state.commands.toggle_node(state)
                    else
                        require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                    end
                end,
                child_or_open = function(state)
                    local node = state.tree:get_node()
                    if node.type == "directory" or node:has_children() then
                        if not node:is_expanded() then
                            state.commands.toggle_node(state)
                        else
                            require("neo-tree.ui.renderer").focus_node(state, node:get_first_child_ids()[1])
                        end
                    else
                        state.commands.open(state)
                    end
                end,
                copy_selector = function(state)
                    local node = state.tree:get_node()
                    local filepath = node.get_id()
                    local filename = node.name
                    local modify = vim.fn.fnamemodify

                    local vals = {
                        ["BASENAME"] = modify(filename, ":r"),
                        ["EXTENSION"] = modify(filename, ":e"),
                        ["FILENAME"] = filename,
                        ["PATH (CWD)"] = modify(filepath, ":."),
                        ["PATH (HOME)"] = modify(filepath, ":~"),
                        ["PATH"] = filepath,
                        ["URI"] = vim.uri_from_fname(filepath),
                    }

                    local options = vim.tal_filter(function(val)
                        return vals[val] ~= ""
                    end, vim.tbl_keys(vals))
                    if vim.tal_isempty(options) then
                        return
                    end
                    table.sort(options)
                    vim.ui.select(options, {
                        prompt = "Choose to copy to clipboard",
                        format_item = function(item)
                            return ("%s: `%s`"):format(item, vals[item])
                        end,
                        function(choice)
                            local result = vals[choice]
                            if result then
                                vim.fn.setreg("+", result)
                            end
                        end,
                    })
                end,
                find_in_dir = function(state)
                    local node = state.tree:get_node()
                    local path = node.type == "file" and node:get_parent_id() or node:get_id()
                    require("telescope.builtin").find_files({
                        cwd = path,
                    })
                end,
                delete = function(state)
                    local node = state.tree:get_node()
                    require("neo-tree").config.filesystem.commands.delete_visual(state, { node })
                end,
                delete_visual = function(state, selected_nodes)
                    local path = {}
                    for _, node in ipairs(selected_nodes) do
                        if node.type ~= "message" then
                            path[#path + 1] = "the POSIX file " .. string.format("%q", node.path)
                        end
                    end

                    local term
                    if #path < 1 then
                        return
                    elseif #path == 1 then
                        term = "this file"
                    else
                        term = #path .. " files"
                    end

                    local inputs = require("neo-tree.ui.inputs")
                    inputs.confirm("Are you sure trash " .. term .. "?", function(confirmed)
                        if not confirmed then
                            return
                        end

                        vim.fn.system({
                            "osascript",
                            "-e",
                            'tell app "Finder" to move {' .. table.concat(path, ",") .. "} to trash",
                        })
                        require("neo-tree.sources.manager").refresh(state.name)
                    end)
                end,
            },
            window = {
                mappings = {
                    ["H"] = "toggle_hidden",
                    ["f"] = "fuzzy_finder",
                    ["F"] = "fuzzy_finder_directory",
                    -- ["/"] = "filter_on_submit",
                    ["/"] = "filter_as_you_type", -- this was the default until v1.28
                    ["<C-c>"] = "clear_filter",
                    ["u"] = "navigate_up",
                    ["."] = "set_root",
                    ["p"] = "prev_git_modified",
                    ["n"] = "next_git_modified",
                },
            },
            async_directory_scan = "auto", -- "auto"   means refreshes are async, but it's synchronous when called from the Neotree commands.
            -- "always" means directory scans are always async.
            -- "never"  means directory scans are never async.
            scan_mode = "never", -- "shallow": Don't scan into directories to detect possible empty directory a priori
            bind_to_cwd = false, -- true creates a 2-way binding between vim's cwd and neo-tree's root
            cwd_target = {
                sidebar = "tab", -- sidebar is when position = left or right
                current = "window", -- current is when position = current
            },
            follow_current_file = { enabled = true }, -- This will find and focus the file in the active buffer every time
            -- the current file is changed while the tree is open.
            hijack_netrw_behavior = "open_current", -- netrw disabled, opening a directory opens neo-tree
            -- in whatever position is specified in window.position
            -- "open_current",-- netrw disabled, opening a directory opens within the
            -- window like netrw would, regardless of window.position
            -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
            use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function(_)
                        vim.opt_local.signcolumn = "auto"
                    end,
                },
            },
        },

        buffers = {
            bind_to_cwd = false,
            follow_current_file = true, -- This will find and focus the file in the active buffer every time
            -- the current file is changed while the tree is open.
            group_empty_dirs = true, -- when true, empty directories will be grouped together
            window = {
                mappings = {
                    ["u"] = "navigate_up",
                    ["."] = "set_root",
                    ["d"] = "buffer_delete",
                },
            },
        },

        git_status = {
            window = {
                mappings = {
                    ["A"] = "git_add_all",
                    ["u"] = "git_unstage_file",
                    ["a"] = "git_add_file",
                    ["r"] = "git_revert_file",
                    ["c"] = "git_commit",
                    ["p"] = "git_push",
                    ["C"] = "git_commit_and_push",
                },
            },
        },

        -- icon settings
        default_component_configs = {
            container = {
                enable_character_fade = true,
                width = "100%",
                right_padding = 0,
            },
            indent = {
                indent_size = 2,
                padding = 0,
                -- indent guides
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                -- expander config, needed for nesting files
                with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "ﰊ",
                folder_empty_open = "ﰊ",
                -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
                -- then these will never be used.
                default = "*",
                highlight = "NeoTreeFileIcon",
            },
            modified = {
                symbol = "[+] ",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    -- Change type
                    added = "✚", -- NOTE: you can set any of these to an empty string to not show them
                    deleted = "✖",
                    modified = "",
                    renamed = "",
                    -- Status type
                    untracked = "",
                    ignored = "",
                    unstaged = " ",
                    staged = "",
                    conflict = "",
                },
                align = "right",
            },
        },
        renderers = {
            directory = {
                { "indent" },
                { "icon" },
                { "current_filter" },
                {
                    "container",
                    content = {
                        { "name", zindex = 10 },
                        -- {
                        --   "symlink_target",
                        --   zindex = 10,
                        --   highlight = "NeoTreeSymbolicLinkTarget",
                        -- },
                        { "clipboard", zindex = 10 },
                        {
                            "diagnostics",
                            errors_only = true,
                            zindex = 20,
                            align = "right",
                            hide_when_expanded = true,
                        },
                        { "git_status", zindex = 20, align = "right", hide_when_expanded = true },
                    },
                },
            },
            file = {
                { "indent" },
                { "icon" },
                {
                    "container",
                    content = {
                        {
                            "name",
                            zindex = 10,
                        },
                        -- {
                        --   "symlink_target",
                        --   zindex = 10,
                        --   highlight = "NeoTreeSymbolicLinkTarget",
                        -- },
                        { "clipboard", zindex = 10 },
                        { "bufnr", zindex = 10 },
                        { "modified", zindex = 20, align = "right" },
                        { "diagnostics", zindex = 20, align = "right" },
                        { "git_status", zindex = 20, align = "right" },
                    },
                },
            },
            message = {
                { "indent", with_markers = true },
                { "name", highlight = "NeoTreeMessage" },
            },
            terminal = {
                { "indent" },
                { "icon" },
                { "name" },
                { "bufnr" },
            },
        },
    }
end

return M
