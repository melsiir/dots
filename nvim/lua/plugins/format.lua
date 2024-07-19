return {

  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        json = { "jq" },
        java = { "astyle" },
        rust = { "rustfmt" },
        python = {"black"},
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },
    },
  },
}
