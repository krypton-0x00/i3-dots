local M = {}

M.enable_format_on_save = function(client, bufnr)
  -- Only enable for Rust and Lua
  local filetype = vim.bo[bufnr].filetype
  if filetype == "rust" or filetype == "lua" then
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("FormatOnSave" .. bufnr, {}),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end
end

return M

