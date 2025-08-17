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
      -- Disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        hijack_cursor = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          
          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end
          
          -- Default mappings
          api.config.mappings.default_on_attach(bufnr)
          
          -- Custom mappings
          vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
          vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
        end,
        view = {
          width = 35,
          side = "left",
          preserve_window_proportions = false,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
          float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
              relative = "editor",
              border = "rounded",
              width = 30,
              height = 30,
              row = 1,
              col = 1,
            },
          },
        },
        renderer = {
          add_trailing = false,
          group_empty = true,
          highlight_git = true,
          full_name = false,
          highlight_opened_files = "none",
          root_folder_label = ":~:s?$?/..?",
          indent_width = 2,
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "before",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "📄",
              symlink = "🔗",
              bookmark = "🔖",
              folder = {
                arrow_closed = "▶",
                arrow_open = "▼",
                default = "📁",
                open = "📂",
                empty = "📁",
                empty_open = "📂",
                symlink = "🔗",
                symlink_open = "🔗",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "⌘",
                renamed = "➜",
                untracked = "★",
                deleted = "⊖",
                ignored = "◌",
              },
            },
          },
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "CMakeLists.txt" },
          symlink_destination = true,
        },
        update_focused_file = {
          enable = true,
          update_root = true,
          ignore_list = {},
        },
        ignore_ft_on_setup = {},
        system_open = {
          cmd = "",
          args = {},
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = "💡",
            info = "ℹ️",
            warning = "⚠️",
            error = "🚨",
          },
        },
        filters = {
          dotfiles = false,
          git_clean = false,
          no_buffer = false,
          custom = {},
          exclude = {},
        },
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
          ignore_dirs = {},
        },
        git = {
          enable = true,
          ignore = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          timeout = 400,
        },
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = {},
          },
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "shadow",
              style = "minimal",
            },
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = true,
              picker = "default",
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          remove_file = {
            close_window = true,
          },
        },
        trash = {
          cmd = "gio trash",
        },
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = true,
        },
        tab = {
          sync = {
            open = false,
            close = false,
            ignore = {},
          },
        },
        notify = {
          threshold = vim.log.levels.INFO,
        },
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
          },
        },
      })
    end
  },

  -- Which key
  { import = "plugins.whichkey" },

  -- Dashboard
  { import = "plugins.dashboard" },

  -- Notifications
  { import = "plugins.notify" },

  -- Themes
  { import = "plugins.theme" },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function lsp_status()
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })
        if #clients == 0 then
          return "🚫 No LSP"
        end
        
        local client_names = {}
        for _, client in pairs(clients) do
          table.insert(client_names, client.name)
        end
        return "🔧 " .. table.concat(client_names, ", ")
      end

      local function git_branch()
        local branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
        if branch ~= "" then
          return "🌿 " .. branch
        end
        return ""
      end

      local function file_info()
        local file = vim.fn.expand("%:t")
        if file == "" then
          return "📄 [No Name]"
        end
        local icon = require("nvim-web-devicons").get_icon(file, vim.fn.expand("%:e"), { default = true })
        return (icon or "📄") .. " " .. file
      end

      local function diagnostics_info()
        local diagnostics = vim.diagnostic.get(0)
        local errors = 0
        local warnings = 0
        local info = 0
        local hints = 0
        
        for _, diagnostic in pairs(diagnostics) do
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            errors = errors + 1
          elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            warnings = warnings + 1
          elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            info = info + 1
          elseif diagnostic.severity == vim.diagnostic.severity.HINT then
            hints = hints + 1
          end
        end
        
        local result = {}
        if errors > 0 then table.insert(result, "🚨 " .. errors) end
        if warnings > 0 then table.insert(result, "⚠️ " .. warnings) end
        if info > 0 then table.insert(result, "ℹ️ " .. info) end
        if hints > 0 then table.insert(result, "💡 " .. hints) end
        
        return table.concat(result, " ")
      end

      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                local mode_map = {
                  ["NORMAL"] = "🟢 NORMAL",
                  ["INSERT"] = "🟡 INSERT",
                  ["VISUAL"] = "🔵 VISUAL",
                  ["V-LINE"] = "🔵 V-LINE",
                  ["V-BLOCK"] = "🔵 V-BLOCK",
                  ["COMMAND"] = "🟠 COMMAND",
                  ["REPLACE"] = "🔴 REPLACE",
                  ["TERMINAL"] = "💻 TERMINAL",
                }
                return mode_map[str] or "⚪ " .. str
              end,
            },
          },
          lualine_b = {
            {
              git_branch,
              color = { fg = "#98be65" },
            },
            {
              "diff",
              symbols = { added = "➕ ", modified = "🔄 ", removed = "➖ " },
              colored = true,
            },
          },
          lualine_c = {
            {
              file_info,
              color = { fg = "#61afef" },
            },
            {
              "filesize",
              fmt = function(str)
                return "📊 " .. str
              end,
            },
          },
          lualine_x = {
            {
              diagnostics_info,
              color = { fg = "#e06c75" },
            },
            {
              lsp_status,
              color = { fg = "#c678dd" },
            },
            {
              "encoding",
              fmt = function(str)
                return "🔤 " .. str
              end,
            },
            {
              "fileformat",
              symbols = {
                unix = "🐧",
                dos = "🪟",
                mac = "🍎",
              },
            },
            {
              "filetype",
              colored = true,
              icon_only = false,
              icon = { align = "right" },
            },
          },
          lualine_y = {
            {
              "progress",
              fmt = function(str)
                return "📍 " .. str
              end,
            },
          },
          lualine_z = {
            {
              "location",
              fmt = function(str)
                return "🎯 " .. str
              end,
            },
            {
              function()
                return "🕐 " .. os.date("%H:%M")
              end,
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { file_info },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
      })
    end
  },

  -- Buffer line
  { import = "plugins.bufferline" },

  -- Telescope (fuzzy finder)
  { import = "plugins.telescope" },

  -- Git integration
  { import = "plugins.git" },

  -- Terminal integration
  { import = "plugins.terminal" },

  -- Debugging
  { import = "plugins.debugging" },

  -- Treesitter
  { import = "plugins.treesitter" },

  -- Completion
  { import = "plugins.cmp" },

  -- Code Snippets
  { import = "plugins.snippets" },

  -- LSP
  { import = "plugins.lsp" },

  -- Rust-specific
  { import = "plugins.rust" },

  -- Additional useful plugins
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        indent = {
          char = "│",
          tab_char = "│",
        },
        scope = { enabled = false },
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "Trouble",
            "trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
      })
    end,
  },
})

