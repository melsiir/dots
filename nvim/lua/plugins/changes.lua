return {
  --add
  -- { "nvim-lualine/lualine.nvim", enabled = false },
  --
  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("onedark")
    end,
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX", "CAUTION" } },
      },
    },
  },
  {
    "norcalli/nvim-colorizer.lua",
    -- event = "Verylazy",
    -- lazy = true,
    opts = {
      "*",
    },
  },
}
