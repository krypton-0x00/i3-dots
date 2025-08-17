-- Auto-formatting on save configuration
local format_on_save = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })

-- Format on save for multiple file types
vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_on_save,
  pattern = { "*.lua", "*.rs", "*.c", "*.cpp", "*.cc", "*.cxx", "*.h", "*.hpp", "*.py", "*.js", "*.ts", "*.jsx", "*.tsx" },
  callback = function()
    -- Only format if LSP is attached and supports formatting
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    for _, client in pairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        vim.lsp.buf.format({ 
          async = false,
          filter = function(c) return c.name ~= "tsserver" end -- Exclude tsserver for JS/TS
        })
        break
      end
    end
  end,
})

-- Special handling for C/C++ files with clang-format fallback
vim.api.nvim_create_autocmd("BufWritePre", {
  group = format_on_save,
  pattern = { "*.c", "*.cpp", "*.cc", "*.cxx", "*.h", "*.hpp" },
  callback = function()
    -- First try LSP formatting, then fallback to clang-format if available
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    local has_lsp_formatter = false
    
    for _, client in pairs(clients) do
      if client.server_capabilities.documentFormattingProvider then
        has_lsp_formatter = true
        break
      end
    end
    
    if not has_lsp_formatter then
      -- Fallback to clang-format if no LSP formatter
      local clang_format = vim.fn.executable("clang-format")
      if clang_format == 1 then
        -- Use clang-format with 4-space indentation
        vim.cmd("silent! %!clang-format --style='{IndentWidth: 4, TabWidth: 4, UseTab: Never}'")
      end
    end
  end,
})

