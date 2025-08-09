-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- File tree
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end
  },
  -- which key

  { import = "plugins.whichkey" },

  -- Theme
  { import = "plugins.theme" },


  -- Status line
  {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        theme = "tokyonight",
        component_separators = "|",
        section_separators = "",
      }
    })
  end
}
,

  -- Treesitter
  { import = "plugins.treesitter" },

  -- Completion
  { import = "plugins.cmp" },

  -- LSP
  { import = "plugins.lsp" },

  -- Rust-specific
  { import = "plugins.rust" },
})

