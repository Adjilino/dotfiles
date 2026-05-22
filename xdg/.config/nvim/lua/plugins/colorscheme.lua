return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      background = { light = "latte", dark = "macchiato" },
      integrations = {
        cmp = true,
        gitsigns = true,
        treesitter = true,
        notify = true,
        mason = true,
        which_key = true,
        mini = { enabled = true },
        telescope = { enabled = true },
        native_lsp = { enabled = true },
      },
    },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin-macchiato" },
  },

  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 999,
    opts = {
      update_interval = 3000,
      set_dark_mode = function()
        vim.opt.background = "dark"
        vim.cmd.colorscheme("catppuccin-macchiato")
      end,
      set_light_mode = function()
        vim.opt.background = "light"
        vim.cmd.colorscheme("catppuccin-latte")
      end,
    },
  },
}
