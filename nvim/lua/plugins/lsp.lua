return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim",           config = true },
    { "williamboman/mason-lspconfig.nvim", config = true },
  },
  config = function()
    local on_attach = require("core.lsp_on_attach").on_attach

    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "rust_analyzer" },
    })

    local lspconfig = require("lspconfig")

    -- Lua
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    -- Rust
    lspconfig.rust_analyzer.setup({
      on_attach = on_attach,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        },
      },
    })
  end,
}
