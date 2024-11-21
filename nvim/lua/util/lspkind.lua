return function(entry, vim_item)
    local lspkind_icons = {
        Text = "",
        Method = "",
        Function = "󰊕",
        Constructor = "󰡱",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = " ",
        Robot = "󱚤",
        Smiley = " ",
        Note = " ",
        Copilot = "",
        Codeium = "",
        FittenCode = "",
    }
    -- load lspkind icons
    vim_item.kind = lspkind_icons[vim_item.kind]
    if entry.source.name == "cmp_tabnine" then
        vim_item.kind = lspkind_icons["Robot"]
        -- vim_item.kind_hl_group = "CmpItemKindTabnine"
    end

    if entry.source.name == "emoji" then
        vim_item.kind = lspkind_icons["Smiley"]
        vim_item.kind_hl_group = "CmpItemKindEmoji"
    end

    if entry.source.name == "look" then
        vim_item.kind = lspkind_icons["Note"]
        -- vim_item.kind_hl_group = "CmpItemKindEmoji"
    end
    vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        path = "[Path]",
        luasnip = "[LuaSnip]",
        codeium = "[Codeium]",
        Copilot = "[Copilot]",
        FittenCode = "[FittenCode ]",
        emoji = "[Emoji]",
        look = "[Dict]",
    })[entry.source.name]

    return vim_item
end
