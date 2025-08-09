return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup({
      plugins = {
        spelling = true, -- show spelling suggestions
      },
      key_labels = {
        ["<leader>"] = "SPC",
      },
    })

      wk.register({
    ["<leader>l"] = {
      name = "LSP",
      e = "Show Diagnostics",
      n = "Next Diagnostic",
      p = "Prev Diagnostic",
      d = "Goto Definition",
      h = "Hover Docs",
      r = "Rename Symbol",
      a = "Code Actions",
      f = "Format File",
    },
  })

  end
}

