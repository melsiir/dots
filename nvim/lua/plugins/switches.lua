-- here you can enable or disable plugins

return {
  { "neovim/nvim-lspconfig", enabled = false },
  { "nvimdev/dashboard-nvim", enabled = true },
  { "hrsh7th/nvim-cmp", enabled = true },

  -- this plugin handle error and warrning messages
  --  and the shape and feel of cmdline and seach bar
  --  make floating cmdline
  { "folke/noice.nvim", enabled = false },
  -- { "rcarriga/nvim-notify", enabled = false },
  { "nvim-treesitter/nvim-treesitter", enabled = true },
  --   -- the this show you where you are in code but iam disable it for now
  { "nvim-treesitter/nvim-treesitter-context", enabled = false },
  -- { "lukas-reineke/indent-blankline.nvim", enabled = false },
  --responsible from tree nvim-treesitter indentation animatiom
  -- { "echasnovski/mini.indentscope", enabled = true },
  { "echasnovski/mini.animate", enabled = false },
}
