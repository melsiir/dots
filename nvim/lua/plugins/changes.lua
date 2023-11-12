return {
  -- { 'nickeb96/fish.vim'},
  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme("onedark")
    -- end,
  },
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
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fP",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files (cwd)",
      },
    },
    -- change some options
    -- opts = {
    --   defaults = {
    --     prompt_prefix = "🌍 ",
    --     selection_caret = " ",
    --
    --     layout_strategy = "horizontal",
    --     layout_config = { prompt_position = "top" },
    --     sorting_strategy = "ascending",
    --     winblend = 0,
    --   },
    -- },
  },
  -- {
  --   "NvChad/ui",
  -- },
}
