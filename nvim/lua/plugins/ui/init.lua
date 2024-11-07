local M = {
    { import = "plugins.ui" },
    { import = "plugins.ui.extra" },
    { import = "plugins.ui.theme.custom" },
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        opts = {
            override = {
                deb = { icon = "", name = "Deb" },
                lock = { icon = "󰌾", name = "Lock" },
                mp3 = { icon = "󰎆", name = "Mp3" },
                mp4 = { icon = "", name = "Mp4" },
                out = { icon = "", name = "Out" },
                ["robots.txt"] = { icon = "󰚩", name = "Robots" },
                ttf = { icon = "", name = "TrueTypeFont" },
                rpm = { icon = "", name = "Rpm" },
                woff = { icon = "", name = "WebOpenFontFormat" },
                woff2 = { icon = "", name = "WebOpenFontFormat2" },
                xz = { icon = "", name = "Xz" },
                zip = { icon = "", name = "Zip" },
            },
            override_by_extension = {
                ["ipp"] = {
                    icon = "",
                    color = "#519aba",
                    cterm_color = 74,
                    name = "Ipp",
                },
                ["launch"] = {
                    icon = "",
                    color = "#ffbc03",
                    cterm_color = 214,
                    name = "Launch",
                },
                ["qmd"] = {
                    icon = "󰠮",
                    color = "#ffbc03",
                    cterm_color = 214,
                    name = "Quarto",
                },
            },
            override_by_filename = {
                ["cmakelists.txt"] = {
                    icon = "",
                    color = "#6d8086",
                    cterm_color = "66",
                    name = "CMakeLists",
                },
                ["Dockerfile"] = {
                    icon = "󰡨",
                    color = "#458ee6",
                    name = "Dockerfile",
                },
                ["Jenkinsfile"] = {
                    icon = "",
                    color = "#519aba",
                    cterm_color = 74,
                    name = "Jenkinsfile",
                },
            },
        },
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end,
    },
}

return M
