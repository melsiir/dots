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
local function line_total()
  local curs = vim.api.nvim_win_get_cursor(0)
  return curs[1] .. "/" .. vim.api.nvim_buf_line_count(vim.fn.winbufnr(0)) .. "," .. curs[2]
end

local function getWords()
  return tostring(vim.fn.wordcount().words)
end

-- local colors = {
--   dark = "#3B4252",
--   white = "#E5E8F1",
-- }
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "arkav/lualine-lsp-progress",
    "linrongbin16/lsp-progress.nvim",
  },

  event = "VeryLazy",
  opts = function(_, opts)
    opts.sections.lualine_z = {}
    opts.sections.lualine_y = {}
    --    opts.sections.lualine_y = { "lsp_progress", "progress", require("lsp-progress").progress }
    opts.sections.lualine_z = { "location" }
    -- table.insert(opts.sections.lualine_x, "progress")
  end,
}
