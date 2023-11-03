return {
  -- add custom snippets to cmp
  -- and change buffer cmp keyword_length

  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      {
        name = "buffer",
        keyword_length = 3,
        -- option = {
        --   keyword_pattern = [[\k\+]],
        -- },
      },
      { name = "path" },
    }
    -- load custom fish snippets
    require("luasnip.loaders.from_vscode").lazy_load({ paths = "./lua/config/snippets" })
  end,
}
