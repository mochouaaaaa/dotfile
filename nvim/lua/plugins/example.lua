-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the uration of LazyVim plugins

return {
  {
    "smart-splits-nvim/smart-splits.nvim",
    version = "^3.0.0",
    lazy = false,
    opts = {
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      move = {
        same_row = false,
        at_edge = "split",
      },
      swap = {
        move_cursor = false,
      },
      mux = {
        backend = "smart-splits-backend-kitty",
      },
    },
    dependencies = {
      {
        "smart-splits-nvim/backend-kitty",
        main = "smart-splits-backend-kitty",
        opts = {
          password = "kitty",
        },
      },
    },
    config = function(_, opts)
      local smart_splits = require("smart-splits")
      smart_splits.setup(opts)

      local utils = require("util.keymap")
      vim.keymap.set({ "n", "t" }, "<C-S-k>", smart_splits.resize_up)
      vim.keymap.set({ "n", "t" }, "<C-S-j>", smart_splits.resize_down)
      vim.keymap.set({ "n", "t" }, "<C-S-h>", smart_splits.resize_left)
      vim.keymap.set({ "n", "t" }, "<C-S-l>", smart_splits.resize_right)

      vim.keymap.set({ "n", "t" }, utils.platform_key.cmd("k"), smart_splits.move_cursor_up)
      vim.keymap.set({ "n", "t" }, utils.platform_key.cmd("j"), smart_splits.move_cursor_down)
      vim.keymap.set({ "n", "t" }, utils.platform_key.cmd("h"), smart_splits.move_cursor_left)
      vim.keymap.set({ "n", "t" }, utils.platform_key.cmd("l"), smart_splits.move_cursor_right)

      -- Cmd+Ctrl+hjkl creates a Kitty pane when the Kitty remote-control
      -- socket is available (local Kitty or kitten ssh). With ordinary SSH,
      -- fall back to a Neovim split on the requested side.
      local function split_pane(direction)
        if vim.env.KITTY_LISTEN_ON and vim.env.KITTY_LISTEN_ON ~= "" then
          local ok, kitty = pcall(require, "smart-splits-backend-kitty.kitty")
          if ok and kitty.split(direction) then
            return
          end
        end

        local commands = {
          left = "leftabove vsplit",
          right = "rightbelow vsplit",
          up = "aboveleft split",
          down = "belowright split",
        }
        vim.cmd(commands[direction])
      end

      vim.keymap.set("n", utils.platform_key.cmd("C-h"), function()
        split_pane("left")
      end, { desc = "Split pane left" })
      vim.keymap.set("n", utils.platform_key.cmd("C-l"), function()
        split_pane("right")
      end, { desc = "Split pane right" })
      vim.keymap.set("n", utils.platform_key.cmd("C-k"), function()
        split_pane("up")
      end, { desc = "Split pane up" })
      vim.keymap.set("n", utils.platform_key.cmd("C-j"), function()
        split_pane("down")
      end, { desc = "Split pane down" })
    end,
  },
  {
    "NotAShelf/direnv.nvim",
    config = function()
      require("direnv").setup({})

      vim.api.nvim_create_autocmd("User", {
        pattern = "DirenvLoaded",
        callback = function()
          -- Code to run after direnv environment is loaded
          vim.notify("Direnv environment loaded!")
        end,
      })
    end,
  },
}
