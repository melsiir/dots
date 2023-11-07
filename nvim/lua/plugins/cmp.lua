return {
  {
    -- add custom snippets to cmp
    -- and change buffer cmp keyword_length

    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      --set up supertab
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
      ----------
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      opts.window = {
        -- disable documentation window for now because
        -- it cause lagging
        documentation = cmp.config.disable,
      }
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      ---------------------------------------
      opts.sources = {
        { name = "nvim_lsp" },
        {
          name = "luasnip",
          -- disable autocompletion in strings and comments
          group_index = 1,
          option = { use_show_condition = true },
          entry_filter = function()
            local context = require("cmp.config.context")
            return not context.in_treesitter_capture("string")
                and not context.in_syntax_group("String")
                and not context.in_treesitter_capture("comment")
              or context.in_syntax_group("Comment")
          end,
        },
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
  },
  -- for supertab
  {
    --NOTE:  Disable default <tab> and <s-tab> behavior in LuaSnip
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
}
