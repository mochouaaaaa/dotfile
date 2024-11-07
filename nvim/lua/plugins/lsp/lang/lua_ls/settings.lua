return {
    Lua = {
        runtime = {
            -- LuaJIT in the case of Neovim
            version = "LuaJIT",
        },
        format = {
            enable = false,
            defaultConfig = {
                indent_style = "space",
                indent_size = "4",
                quote_style = "single",
                --   align_if_branch = false,
                -- align_array_table = false,
                -- align_continuous_assign_statement = false,
                -- align_continuous_rect_table_field = false,
                align_call_args = "false",
                align_function_params = "false",
                align_continuous_assign_statement = "false",
                align_continuous_rect_table_field = "false",
                align_array_table = "true",
            },
        },
        diagnostics = {
            disable = { "lowercase-global" },
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
        },
        workspace = {
            checkThirdParty = false,
            ignoreDir = { ".vscode", "node_modules" },
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
            enable = false,
        },
        hint = {
            enable = true,
            arrayIndex = "Enable",
            setType = true,
        },
    },
}
