return {
  "neovim/nvim-lspconfig",
  enabled = false,
  -- dependencies = {
  --   { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
  -- },
  opts = {
    servers = {
      lua_ls = {
        --do not install with mason
        mason = false,
      },
    },
  },
}
