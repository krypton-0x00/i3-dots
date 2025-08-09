return {
  "neovim/nvim-lspconfig",
  config = function()
    local format_on_save = require("core.format_on_save")
    local lspconfig = require("lspconfig")

    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      local map = vim.keymap.set

      -- LSP keymaps
      map("n", "<leader>le", vim.diagnostic.open_float, opts)
      map("n", "<leader>ln", vim.diagnostic.goto_next, opts)
      map("n", "<leader>lp", vim.diagnostic.goto_prev, opts)
      map("n", "<leader>ld", vim.lsp.buf.definition, opts)
      map("n", "<leader>lh", vim.lsp.buf.hover, opts)
      map("n", "<leader>lr", vim.lsp.buf.rename, opts)
      map("n", "<leader>la", vim.lsp.buf.code_action, opts)
      map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, opts)

      -- Enable autoformat for Rust and Lua
      format_on_save.enable_format_on_save(client, bufnr)
    end

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls", "rust_analyzer" },
      automatic_installation = true,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    for _, server in ipairs({ "lua_ls", "rust_analyzer" }) do
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  end
}

