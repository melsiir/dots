return {
  {
    "neovim/nvim-lspconfig",
    opts = {

      -- disable in favor of rustaceanvim
      setup = {
        rust_analyzer = function()
          return true
        end,
      },

      servers = {
        html = {
          enabled = true,
          mason = true,
        },
        emmet_ls = {
          enabled = true,
          mason = true,
        },
        cssls = {
          enabled = true,
          mason = true,
        },
        lua_ls = {
          enabled = false,
          --do not install with mason
          mason = false,
        },

        clangd = {
          --do not install with mason
          mason = false,
        },
        ruff_lsp = {
          --do not install with mason
          mason = false,
          enabled = false,
        },
        -- shfmt = {
        --   mason = false,
        -- },
        -- stylua = {
        --   --do not install with mason
        --   mason = false,
        -- },
        --
        -- codelldb = {
        --   mason = false,
        -- },

        -- rust_analyzer = {
        --   mason = false,
        --   keys = {
        --     { "<leader>cc", "<cmd>RustRunnables<cr>", desc = "Run rust" },
        --     { "<leader>ck", "<cmd>!cd %;!cargo run --bin %<cr>", desc = "Rust last runs" },
        --   },
        -- },
      },
    },
  },
  -- {
  --   "mrcjkb/rustaceanvim",
  --   opts = function()
  --     -- Update this path
  --     -- local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/"
  --     local extension_path = vim.env.HOME .. ".codelldb/extension"
  --     local codelldb_path = extension_path .. "adapter/codelldb"
  --     local liblldb_path = extension_path .. "lldb/lib/liblldb"
  --     local this_os = vim.uv.os_uname().sysname
  --
  --     -- The path is different on Windows
  --     if this_os:find("Windows") then
  --       codelldb_path = extension_path .. "adapter\\codelldb.exe"
  --       liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  --     else
  --       -- The liblldb extension is .so for Linux and .dylib for MacOS
  --       liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
  --     end
  --
  --     local cfg = require("rustaceanvim.config")
  --     return {
  --       dap = {
  --         adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
  --       },
  --     }
  --   end,
  -- },
}
