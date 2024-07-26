vim.g.loaded_python3_provider = 1

return {
    basedpyright = {
        disableLanguageServices = false,
        disableOrganizeImports = false,
        completion = {
            importSupport = true,
        },
        typeCheckingMode = "standard",
        reportAttributeAccessIssue = "none",
    },
    python = {
        analysis = {
            autoSearchPaths = true,
            autoImportCompletions = true,
            diagnosticMode = "workspace",
            strictListInference = true,
            strictDictionaryInference = true,
            strictSetInference = true,
            useLibraryCodeForTypes = true,
            reportAny = "off",
            reportAssignmentType = "none",
            reportMissingTypeStubs = "off",
            reportUnusedCallResult = "off",
            reportUnknownValerType = "off",
            reportImplicitStringConcatenation = "off",
            reportAttributeAccessIssue = "none",
        },
        inlayHints = {
            functionReturnTypes = true,
            variableTypes = true,
        },
    },
}
