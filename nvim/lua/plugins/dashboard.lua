return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("dashboard").setup({
      theme = "doom",
      config = {
        header = {
          "",
          "  ██████╗ ██████╗ ██████╗ ███████╗    ██████╗ ███████╗██╗   ██╗",
          " ██╔════╝██╔═══██╗██╔══██╗██╔════╝    ██╔══██╗██╔════╝██║   ██║",
          " ██║     ██║   ██║██║  ██║█████╗      ██║  ██║█████╗  ██║   ██║",
          " ██║     ██║   ██║██║  ██║██╔══╝      ██║  ██║██╔══╝  ╚██╗ ██╔╝",
          " ╚██████╗╚██████╔╝██████╔╝███████╗    ██████╔╝███████╗ ╚████╔╝ ",
          "  ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝    ╚═════╝ ╚══════╝  ╚═══╝  ",
          "",
          "        🚀 Enhanced C/C++ Development Environment 🚀",
          "",
        },
        center = {
          {
            icon = "📁 ",
            icon_hl = "Title",
            desc = "Find Files                 ",
            desc_hl = "String",
            key = "f",
            keymap = "SPC f f",
            key_hl = "Number",
            action = "lua require('telescope.builtin').find_files()"
          },
          {
            icon = "📚 ",
            icon_hl = "Title",
            desc = "Recent Files              ",
            desc_hl = "String",
            key = "r",
            keymap = "SPC f r",
            key_hl = "Number",
            action = "lua require('telescope.builtin').oldfiles()"
          },
          {
            icon = "🔍 ",
            icon_hl = "Title",
            desc = "Find Text                 ",
            desc_hl = "String",
            key = "g",
            keymap = "SPC f g",
            key_hl = "Number",
            action = "lua require('telescope.builtin').live_grep()"
          },
          {
            icon = "⚙️  ",
            icon_hl = "Title",
            desc = "Configuration             ",
            desc_hl = "String",
            key = "c",
            keymap = "SPC f c",
            key_hl = "Number",
            action = "lua require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config')})"
          },
          {
            icon = "🔀 ",
            icon_hl = "Title",
            desc = "Git Status                ",
            desc_hl = "String",
            key = "s",
            keymap = "SPC g g",
            key_hl = "Number",
            action = "LazyGit"
          },
          {
            icon = "💻 ",
            icon_hl = "Title",
            desc = "Terminal                  ",
            desc_hl = "String",
            key = "t",
            keymap = "C-\\",
            key_hl = "Number",
            action = "lua _FLOAT_TOGGLE()"
          },
          {
            icon = "🎨 ",
            icon_hl = "Title",
            desc = "Change Theme              ",
            desc_hl = "String",
            key = "h",
            keymap = "SPC t t",
            key_hl = "Number",
            action = "lua vim.cmd('Telescope colorscheme')"
          },
          {
            icon = "🚪 ",
            icon_hl = "Title",
            desc = "Quit                      ",
            desc_hl = "String",
            key = "q",
            keymap = "SPC q",
            key_hl = "Number",
            action = "qa"
          },
        },
        footer = {
          "",
          "🔧 LSP: C/C++, Rust, Lua, Python | 🎨 Themes: Tokyo Night, Gruvbox, Catppuccin, Nord",
          "🔍 Telescope | 🔀 Git Integration | 🐛 DAP Debugging | 💻 Terminal Integration",
          "",
          "Press ? for help • Space for commands",
        }
      },
    })
  end,
}
