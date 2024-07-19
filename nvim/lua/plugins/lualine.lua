--only show if the disply width is larger than 76
-- function willshow(a)
--   local syswidth = vim.fn.winwidth("%")
--   if syswidth < 76 then
--     return ""
--   end
--   if syswidth >= 76 then
--     return a
--   end
-- end

-- Custom statusline that shows total line number with current
-- local function line_total()
--   local curs = vim.api.nvim_win_get_cursor(0)
--   return curs[1] .. "/" .. vim.api.nvim_buf_line_count(vim.fn.winbufnr(0)) .. "," .. curs[2]
-- end
--
-- local function getWords()
--   return tostring(vim.fn.wordcount().words)
-- end
--
-- -- local colors = {
-- --   dark = "#3B4252",
-- --   white = "#E5E8F1",
-- -- }
-- local function Search()
--   if vim.v.hlsearch == 0 then
--     return ""
--   end
--   local lastsearch = vim.fn.getreg("/")
--   if not lastsearch or lastsearch == "" then
--     return ""
--   end
--   local searchcount = vim.fn.searchcount({ maxcount = 9999 })
--   return lastsearch .. "(" .. searchcount.current .. "/" .. searchcount.total .. ")"
-- end
--
-- local function Location()
--   return " %3l:%-2v"
-- end
--
--
--
local empty_component_separators = { left = "", right = "" }
-- style-1: A > B > C ---- X < Y < Z
local angle_component_separators = { left = "", right = "" }
local angle_section_separators = { left = "", right = "" }

-- style-2: A \ B \ C ---- X / Y / Z
local slash_component_separators = { left = "", right = "" }
local slash_section_separators = { left = "", right = "" }
return {
  {
    "linrongbin16/lsp-progress.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lsp-progress").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "arkav/lualine-lsp-progress",
      "linrongbin16/lsp-progress.nvim",
    },

    event = "VeryLazy",
    opts = function(_, opts)
      -- section_separators = '',
      -- empty separator does not interupt neovim stock startup screen
      -- opts.options.section_separators = empty_component_separators
      -- opts.options.component_separators = empty_component_separators
      opts.sections.lualine_z = {}
      opts.sections.lualine_y = {}
      opts.sections.lualine_y = {
        "progress",
        require("lsp-progress").progress,
      }
      opts.sections.lualine_z = { "location" }
      -- table.insert(opts.sections.lualine_x, "progress")
    end,
  },
}
