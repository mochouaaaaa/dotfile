local M = {}
local Util = require("lazyvim.util")

--- Helper function to check if any active LSP clients given a filter provide a specific capability
---@param capability string The server capability to check for (example: "documentFormattingProvider")
---@param filter vim.lsp.get_active_clients.filter|nil (table|nil) A table with
---              key-value pairs used to filter the returned clients.
---              The available keys are:
---               - id (number): Only return clients with the given id
---               - bufnr (number): Only return clients attached to this buffer
---               - name (string): Only return clients with the given name
---@return boolean # Whether or not any of the clients provide the capability
function M.has_capability(capability, filter)
    for _, client in ipairs(vim.lsp.get_active_clients(filter)) do
        if client.supports_method(capability) then
            return true
        end
    end
    return false
end

local function add_buffer_autocmd(augroup, bufnr, autocmds)
    if not vim.tbl_islist(autocmds) then
        autocmds = { autocmds }
    end
    local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
    if not cmds_found or vim.tbl_isempty(cmds) then
        vim.api.nvim_create_augroup(augroup, { clear = false })
        for _, autocmd in ipairs(autocmds) do
            local events = autocmd.events
            autocmd.events = nil
            autocmd.group = augroup
            autocmd.buffer = bufnr
            vim.api.nvim_create_autocmd(events, autocmd)
        end
    end
end

local function del_buffer_autocmd(augroup, bufnr)
    local cmds_found, cmds = pcall(vim.api.nvim_get_autocmds, { group = augroup, buffer = bufnr })
    if cmds_found then
        vim.tbl_map(function(cmd)
            vim.api.nvim_del_autocmd(cmd.id)
        end, cmds)
    end
end

function M.setup(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- keymap settings

    vim.keymap.set("n", "<leader>wl", function()
        vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, {
        buffer = bufnr,
        noremap = true,
        silent = true,
        desc = "List workspace folders",
    })

    vim.keymap.set("n", "<leader>wa", function()
        vim.lsp.buf.add_workspace_folder()
    end, {
        buffer = bufnr,
        noremap = true,
        silent = true,
        desc = "Add workspace folder",
    })

    vim.keymap.set("n", "<leader>wr", function()
        vim.lsp.buf.remove_workspace_folder()
    end, {
        buffer = bufnr,
        noremap = true,
        silent = true,
        desc = "Remove workspace folder",
    })

    if client.supports_method("textDocument/codeLens") then
        add_buffer_autocmd("lsp_codelens_refresh", bufnr, {
            events = { "InsertLeave", "BufEnter" },
            desc = "Refresh codelens",
            callback = function()
                if not M.has_capability("textDocument/codeLens", { bufnr = bufnr }) then
                    del_buffer_autocmd("lsp_codelens_refresh", bufnr)
                    return
                end
                if vim.g.codelens_enabled then
                    vim.lsp.codelens.refresh()
                end
            end,
        })
        if vim.g.codelens_enabled then
            vim.lsp.codelens.refresh()
        end
    end

    if client.supports_method("textDocument/codeAction") then
        local code_actions
        if Util.has("actions-preview.nvim") then
            code_actions = require("actions-preview").code_actions
        else
            code_actions = function()
                local context = { diagnostic = vim.lsp.diagnostic.get_line_diagnostics() }
                local params = vim.lsp.util.make_range_params()
                params.context = context
                vim.lsp.buf_request(0, "textDocument/codeAction", params, function(err, result, ctx, config) end)
            end
        end
        vim.keymap.set({ "n", "v" }, "<leader>ca", code_actions, { buffer = bufnr, desc = "Code Action Diagnostic" })
    end

    if client.supports_method("textDocument/hover") then
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
    end

    if client.supports_method("textDocument/declaration") then
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
    end

    if client.supports_method("textDocument/definition") then
        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition({ jump_to_single_result = true })
        end, { buffer = bufnr, desc = "Go to definition" })
    end

    if client.supports_method("textDocument/typeDefinition") then
        vim.keymap.set("n", "td", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Definition of current type" })
    end

    if client.supports_method("textDocument/references") then
        local context = { ignore_current_line = true, includeDeclaration = false }
        vim.keymap.set("n", "gr", function()
            vim.lsp.buf.references({ context, nil })
        end, { buffer = bufnr, desc = "Go to references" })
    end

    if client.supports_method("textDocument/rename") then
        if Util.has("inc-rename.nvim") then
            local inc_rename = require("inc_rename")
            vim.keymap.set("n", "<leader>rn", function()
                return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
            end, { buffer = bufnr, expr = true, desc = "Rename" })
        else
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })
        end
    end

    if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client.supports_method("textDocument/documentHighlight") then
        add_buffer_autocmd("lsp_document_highlight", bufnr, {
            {
                events = { "CursorHold", "CursorHoldI" },
                desc = "highlight references when cursor holds",
                callback = function()
                    if not M.has_capability("textDocument/documentHighlight", { bufnr = bufnr }) then
                        del_buffer_autocmd("lsp_document_highlight", bufnr)
                        return
                    end
                    vim.lsp.buf.document_highlight()
                end,
            },
            {
                events = { "CursorMoved", "CursorMovedI", "BufLeave" },
                desc = "clear references when cursor moves",
                callback = function()
                    vim.lsp.buf.clear_references()
                end,
            },
        })
    end

    if Util.has("nvim-navic") then
        navic = require("nvim-navic")
        if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
        end
    end
end

function M.make_capabilities(override)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.documentationFormat = {
        "markdown",
        "plaintext",
    }
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = {
        valueSet = { 1 },
    }
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    return override and vim.tal_deep_extend("keep", capabilities, override) or capabilities
end

return M
