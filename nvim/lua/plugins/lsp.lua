return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim",           config = true },
    { "williamboman/mason-lspconfig.nvim", config = true },
  },
  config = function()
    local on_attach = require("core.lsp_on_attach").on_attach

    require("mason-lspconfig").setup({
      ensure_installed = { 
        "lua_ls", 
        "rust_analyzer", 
        "clangd",           -- C/C++
        "pyright",          -- Python
        "tsserver",         -- TypeScript/JavaScript
        "bashls",           -- Bash
        "cmake",            -- CMake
      },
    })

    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Lua
    lspconfig.lua_ls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
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
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = { command = "clippy" },
        },
      },
    })

    -- C/C++
    lspconfig.clangd.setup({
      on_attach = on_attach,
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style={IndentWidth: 4, TabWidth: 4, UseTab: Never}",
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    })

    -- Python
    lspconfig.pyright.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- TypeScript/JavaScript
    lspconfig.tsserver.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- Bash
    lspconfig.bashls.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- CMake
    lspconfig.cmake.setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
}
