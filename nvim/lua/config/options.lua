-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.relativenumber = false -- Relative line numbers
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.confirm = false -- Confirm to save changes before exiting modified buffer
opt.cursorline = false -- Enable highlighting of the current line
opt.wrap = true -- Disable line wrap

function RunCode()
  local currentFileType = vim.bo.filetype
  local save_cursor = vim.fn.getpos(".")
  local save_view = vim.fn.winsaveview()
  -- the % will apply the command to entire buffer
  if currentFileType == "rust" then
    vim.api.nvim_command(":!cargo run ")
  elseif vim.fn.executable("shfmt") == 1 and currentFileType == "sh" then
    vim.api.nvim_command(":%!shfmt")
  elseif vim.fn.executable("stylua") == 1 and currentFileType == "lua" then
    vim.api.nvim_command(
      ":%!stylua - --indent-type Spaces --indent-width 2 --call-parentheses None --quote-style AutoPreferDouble"
    )
  elseif vim.fn.executable("jq") == 1 and currentFileType == "json" then
    vim.api.nvim_command(":%!jq")
  else
    vim.api.nvim_command("normal! ggVG")
    vim.api.nvim_command("normal! ==")
    -- vim.api.nvim_command(':%s/ *$')
    -- remove white space at the end of lines
    vim.api.nvim_command(":%s/\\s\\+$//e")

    --remove spaces
    -- vim.api.nvim_command(':%s/ *)/)/g')
    -- vim.api.nvim_command(':%s/( */(/g')
    -- vim.api.nvim_command(':%s/ *}/}/g')
    -- vim.api.nvim_command(':%s/{ */{/g')
  end
  --return to where you were before formating
  vim.fn.setpos(".", save_cursor)
  vim.fn.winrestview(save_view)
end

-- function FormatBuffer()
--   local currentFileType = vim.bo.filetype
--   local save_cursor = vim.fn.getpos(".")
--   local save_view = vim.fn.winsaveview()
--   -- the % will apply the command to entire buffer
--   if currentFileType == "fish" then
--     vim.api.nvim_command(":%!fish_indent")
--   elseif vim.fn.executable("shfmt") == 1 and currentFileType == "sh" then
--     vim.api.nvim_command(":%!shfmt")
--   elseif vim.fn.executable("stylua") == 1 and currentFileType == "lua" then
--     vim.api.nvim_command(":%!stylua - --indent-type Spaces --indent-width 2 --call-parentheses None --quote-style AutoPreferDouble")
--   elseif vim.fn.executable("jq") == 1 and currentFileType == "json" then
--     vim.api.nvim_command(":%!jq")
--   else
--     vim.api.nvim_command("normal! ggVG")
--     vim.api.nvim_command("normal! ==")
--     -- vim.api.nvim_command(':%s/ *$')
--     -- remove white space at the end of lines
--     vim.api.nvim_command(":%s/\\s\\+$//e")
--
--     --remove spaces
--     -- vim.api.nvim_command(':%s/ *)/)/g')
--     -- vim.api.nvim_command(':%s/( */(/g')
--     -- vim.api.nvim_command(':%s/ *}/}/g')
--     -- vim.api.nvim_command(':%s/{ */{/g')
--   end
--   --return to where you were before formating
--   vim.fn.setpos(".", save_cursor)
--   vim.fn.winrestview(save_view)
-- end
