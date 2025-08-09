return {
  "folke/tokyonight.nvim",
  lazy = false, -- Load immediately
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "storm", -- storm, moon, night, day
      transparent = true, -- Enable transparency
      terminal_colors = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    })

    vim.cmd.colorscheme("tokyonight")
  end
}

