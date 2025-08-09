return {
  "simrat39/rust-tools.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  config = function()
    local on_attach = require("core.lsp_on_attach").on_attach
    require("rust-tools").setup({
      server = {
        on_attach = on_attach,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      }
    })
  end
}

