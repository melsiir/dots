return {
    {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    -- config = function()
    --   vim.cmd.colorscheme("onedark")
    -- end,
  },
  {
     'shaunsingh/solarized.nvim'
  },
  {
  "Tsuzat/NeoSolarized.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    -- config = function()
    --   vim.cmd [[ colorscheme NeoSolarized ]]
    -- end
},
  {
    'svrana/neosolarized.nvim',
    -- enabled = false,
      -- priority = 1000, -- make sure to load this before all the other start plugins

    dependencies = { 'tjdevries/colorbuddy.nvim' }
  },
  {
  'projekt0n/github-nvim-theme',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    require('github-theme').setup({
      -- ...
    })

    -- vim.cmd('colorscheme github_dark')
  end,
}
}
