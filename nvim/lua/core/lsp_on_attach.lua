local M = {}

M.on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, silent = true, noremap = true }

  -- LSP keymaps
  vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, opts)       -- Show diagnostics
  vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, opts)       -- Quickfix list
  vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)          -- Go to definition
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)              -- Rename symbol
  vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)               -- Hover doc
  vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)      -- Go to implementation
  vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)      -- Signature help

  -- Format on save for Rust & Lua
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end
end

return M

