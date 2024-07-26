return {
  -- { 'nickeb96/fish.vim'},

  --   { 'gen740/SmoothCursor.nvim',
  --   config = function()
  --     require('smoothcursor').setup()
  --   end
  -- },
  {
    "folke/todo-comments.nvim",
    opts = {
      keywords = {
        WARN = { alt = { "WARNING", "XXX", "CAUTION" } },
      },
    },
    -- opts = function(_, opts)
    --   table.insert(opts.keywords.WARN, "CAUTION")
    -- end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    -- event = "Verylazy",
    -- lazy = true,
    opts = {
      "*",
    },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { -- example for lazy-loading and keymap
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    -- to add ignore list add it to your home .gitignore
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fP",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      -- {
      --   "<leader>ff",
      --   function()
      --     require("telescope.builtin").find_files()
      --   end,
      --   desc = "Find Files (cwd)",
      -- },
    },
    -- change some options
    -- opts = {
    --   defaults = {
    --     file_ignore_patterns = { "^node_modules/", "*/node_modules/" },
    --     prompt_prefix = "🌍 ",
    --     selection_caret = " ",
    --     layout_strategy = "horizontal",
    --     layout_config = { prompt_position = "top" },
    --     sorting_strategy = "ascending",
    --     winblend = 0,
    --   },
    -- },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
},
}
