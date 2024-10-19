local telescope = require("telescope")

local M = {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        {
            "jonarrien/telescope-cmdline.nvim",
            config = function()
                telescope.load_extension("cmdline")
            end,
        },
        {
            "catgoose/telescope-helpgrep.nvim",
            config = function()
                telescope.load_extension("helpgrep")
            end,
        },
        {
            "tsakirist/telescope-lazy.nvim",
            config = function()
                telescope.load_extension("lazy")
            end,
        },
        {
            "ryanmsnyder/toggleterm-manager.nvim",
        },
        {
            -- file history undo
            "debugloop/telescope-undo.nvim",
            config = function()
                telescope.load_extension("undo")
            end,
        },
        {
            -- hook lsp ui
            "gbrlsnchs/telescope-lsp-handlers.nvim",
            config = function()
                telescope.load_extension("lsp_handlers")
            end,
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
                telescope.load_extension("fzf")
            end,
        },
        {
            -- dap config
            "nvim-telescope/telescope-dap.nvim",
            config = function()
                telescope.load_extension("dap")
            end,
        },
        {
            -- read file
            "nvim-telescope/telescope-media-files.nvim",
            config = function()
                telescope.load_extension("media_files")
            end,
        },
        {
            -- hook git commit
            "olacin/telescope-cc.nvim",
            config = function()
                telescope.load_extension("conventional_commits")
            end,
        },
        {
            "nvim-telescope/telescope-file-browser.nvim",
            config = function()
                telescope.load_extension("file_browser")
            end,
        },
        {
            "lpoto/telescope-docker.nvim",
            config = function()
                telescope.load_extension("docker")
            end,
        },
    },
}

M.keys = require("plugins.telescope.extensions_keys")

function M.opts(_, opts)
    require("telescope").setup({
        extensions = require("plugins.telescope.extensions"),
    })

    local Util = require("lazyvim.util")
    if not Util.has("flash.nvim") then
        return
    end
    local function flash(prompt_bufnr)
        require("flash").jump({
            pattern = "^",
            label = { after = { 0, 0 } },
            search = {
                mode = "search",
                exclude = {
                    function(win)
                        return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                    end,
                },
            },
            action = function(match)
                local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                picker:set_selection(match.pos[1] - 1)
            end,
        })
    end
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
    })
end

return M
