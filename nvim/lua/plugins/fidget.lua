return { -- LSP Progresss UI
  "j-hui/fidget.nvim",
  lazy = true, -- Loaded by `lspconfig`.
  -- version = false,
  -- tag = "legacy", -- To avoid breaking changes for now. Maybe test newer versions at some point.
  enabled = false,
  -- Related documentation: "https://github.com/j-hui/fidget.nvim/blob/main/doc/fidget.md"
  config = function()
    require("fidget").setup({
      text = {
        spinner = "dots", -- Animation shown when tasks are ongoing.
        done = "✔", -- Character shown when all tasks are complete.
        commenced = "Started", -- Message shown when task starts.
        completed = "Completed", -- Message shown when task completes.
      },

      align = {
        bottom = true, -- Align fidgets along bottom edge of buffer.
        right = true, -- Align fidgets along right edge of buffer.
      },

      timer = {
        spinner_rate = 125, -- Frame rate of spinner animation, in ms.
        fidget_decay = 2000, -- How long to keep around empty fidget, in ms.
        task_decay = 1000, -- How long to keep around completed task, in ms.
      },

      window = {
        relative = "win", -- Where to anchor, either "win" or "editor".
        blend = 100, -- &winblend for the window.
        zindex = nil, -- The zindex value for the window.
        border = "none", -- Style of border for the fidget window.
      },

      fmt = {
        leftpad = true, -- Right-justify text in fidget box.
        stack_upwards = true, -- List of tasks grows upwards.
        max_width = 0, -- Maximum width of the fidget box.

        fidget = function(fidget_name, spinner)
          return string.format("%s %s", spinner, fidget_name)
        end,

        task = function(task_name, message, percentage)
          return string.format(
            "%s%s [%s]",
            message,
            percentage and string.format(" (%s%%)", percentage) or "",
            task_name
          )
        end,
      },
    })
  end,
}
