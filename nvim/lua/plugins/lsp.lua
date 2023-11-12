return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      lua_ls = {
        --do not install with mason
        mason = false,
      },
    },
  },
}
