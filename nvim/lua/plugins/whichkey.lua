return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")

    wk.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = {
          enabled = true,
          suggestions = 20,
        },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      operators = { gc = "Comments" },
      key_labels = {
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
      },
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      popup_mappings = {
        scroll_down = "<c-d>",
        scroll_up = "<c-u>",
      },
      window = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 1, 2, 1, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      ignore_missing = true,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
      show_help = true,
      show_keys = true,
      triggers = "auto",
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      },
    })

    -- Register all keybindings with icons and descriptions
    wk.register({
      -- File operations
      ["<leader>w"] = { "<cmd>w<cr>", "💾 Save File" },
      ["<leader>q"] = { "<cmd>q<cr>", "🚪 Quit" },
      ["<leader>x"] = { "<cmd>x<cr>", "💾🚪 Save & Quit" },
      ["<leader>e"] = { "<cmd>NvimTreeToggle<cr>", "🌳 Toggle File Tree" },
      ["<leader>h"] = { "<cmd>nohlsearch<cr>", "🔍 Clear Search Highlight" },

      -- Find/Search operations
      ["<leader>f"] = {
        name = "🔍 Find",
        f = { "<cmd>Telescope find_files<cr>", "📁 Find Files" },
        g = { "<cmd>Telescope live_grep<cr>", "🔎 Live Grep" },
        b = { "<cmd>Telescope buffers<cr>", "📋 Find Buffers" },
        h = { "<cmd>Telescope help_tags<cr>", "❓ Help Tags" },
        r = { "<cmd>Telescope oldfiles<cr>", "📚 Recent Files" },
        c = { "<cmd>Telescope grep_string<cr>", "🎯 Find String Under Cursor" },
        s = { "<cmd>Telescope lsp_document_symbols<cr>", "📄 Document Symbols" },
        S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "🏢 Workspace Symbols" },
      },

      -- LSP operations
      ["<leader>l"] = {
        name = "🔧 LSP",
        e = { "<cmd>lua vim.diagnostic.open_float()<cr>", "🚨 Show Diagnostics" },
        n = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "⬇️ Next Diagnostic" },
        p = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "⬆️ Prev Diagnostic" },
        d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "🎯 Goto Definition" },
        D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "📋 Goto Declaration" },
        h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "📖 Hover Docs" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "🔧 Goto Implementation" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "✏️ Rename Symbol" },
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "⚡ Code Actions" },
        f = { "<cmd>lua vim.lsp.buf.format()<cr>", "🎨 Format File" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "📝 Signature Help" },
        t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "🏷️ Type Definition" },
        R = { "<cmd>lua vim.lsp.buf.references()<cr>", "🔗 References" },
      },

      -- Git operations
      ["<leader>g"] = {
        name = "🔀 Git",
        g = { "<cmd>LazyGit<cr>", "🦥 LazyGit" },
        s = { "<cmd>Gitsigns stage_hunk<cr>", "➕ Stage Hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "↩️ Reset Hunk" },
        S = { "<cmd>Gitsigns stage_buffer<cr>", "📋➕ Stage Buffer" },
        u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "↶ Undo Stage Hunk" },
        R = { "<cmd>Gitsigns reset_buffer<cr>", "📋↩️ Reset Buffer" },
        p = { "<cmd>Gitsigns preview_hunk<cr>", "👁️ Preview Hunk" },
        b = { "<cmd>Gitsigns blame_line<cr>", "👤 Blame Line" },
        d = { "<cmd>Gitsigns diffthis<cr>", "🔄 Diff This" },
      },

      -- Debug operations
      ["<leader>d"] = {
        name = "🐛 Debug",
        b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "🔴 Toggle Breakpoint" },
        c = { "<cmd>lua require'dap'.continue()<cr>", "▶️ Continue" },
        i = { "<cmd>lua require'dap'.step_into()<cr>", "⬇️ Step Into" },
        o = { "<cmd>lua require'dap'.step_over()<cr>", "➡️ Step Over" },
        O = { "<cmd>lua require'dap'.step_out()<cr>", "⬆️ Step Out" },
        r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "💬 Toggle REPL" },
        l = { "<cmd>lua require'dap'.run_last()<cr>", "🔄 Run Last" },
        u = { "<cmd>lua require'dapui'.toggle()<cr>", "🖥️ Toggle DAP UI" },
        t = { "<cmd>lua require'dap'.terminate()<cr>", "⏹️ Terminate" },
      },

      -- Terminal operations
      ["<leader>t"] = {
        name = "💻 Terminal",
        h = { "<cmd>lua _HORIZONTAL_TOGGLE()<cr>", "➖ Horizontal Terminal" },
        v = { "<cmd>lua _VERTICAL_TOGGLE()<cr>", "➗ Vertical Terminal" },
        f = { "<cmd>lua _FLOAT_TOGGLE()<cr>", "🎈 Float Terminal" },
        t = { function()
          local themes = { "tokyonight", "gruvbox", "catppuccin", "nord" }
          local current_theme = vim.g.colors_name
          local current_index = 1
          
          for i, theme in ipairs(themes) do
            if theme == current_theme then
              current_index = i
              break
            end
          end
          
          local next_index = (current_index % #themes) + 1
          vim.cmd.colorscheme(themes[next_index])
          print("🎨 Switched to " .. themes[next_index])
        end, "🎨 Toggle Themes" },
        b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "👤 Toggle Line Blame" },
        d = { "<cmd>Gitsigns toggle_deleted<cr>", "🗑️ Toggle Deleted" },
      },

      -- Buffer operations
      ["<leader>b"] = {
        name = "📋 Buffer",
        d = { "<cmd>bdelete<cr>", "🗑️ Delete Buffer" },
        p = { "<cmd>BufferLinePickClose<cr>", "🎯 Pick Buffer to Close" },
        l = { "<cmd>BufferLineCloseRight<cr>", "➡️🗑️ Close Buffers Right" },
        h = { "<cmd>BufferLineCloseLeft<cr>", "⬅️🗑️ Close Buffers Left" },
      },

      -- Window operations
      ["<leader>s"] = {
        name = "🪟 Split",
        v = { "<cmd>vsplit<cr>", "➗ Split Vertically" },
        h = { "<cmd>split<cr>", "➖ Split Horizontally" },
      },

      -- Quickfix operations
      ["<leader>c"] = {
        name = "🔧 Quickfix",
        o = { "<cmd>copen<cr>", "📂 Open Quickfix List" },
        c = { "<cmd>cclose<cr>", "❌ Close Quickfix List" },
      },

      -- Hunk operations (Git)
      ["<leader>h"] = {
        name = "🔀 Hunk",
        s = { "<cmd>Gitsigns stage_hunk<cr>", "➕ Stage Hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "↩️ Reset Hunk" },
        S = { "<cmd>Gitsigns stage_buffer<cr>", "📋➕ Stage Buffer" },
        u = { "<cmd>Gitsigns undo_stage_hunk<cr>", "↶ Undo Stage Hunk" },
        R = { "<cmd>Gitsigns reset_buffer<cr>", "📋↩️ Reset Buffer" },
        p = { "<cmd>Gitsigns preview_hunk<cr>", "👁️ Preview Hunk" },
        b = { "<cmd>Gitsigns blame_line<cr>", "👤 Blame Line" },
        d = { "<cmd>Gitsigns diffthis<cr>", "🔄 Diff This" },
        D = { "<cmd>lua require('gitsigns').diffthis('~')<cr>", "🔄 Diff This ~" },
      },

      -- Snippets
      ["<leader>n"] = {
        name = "📝 Snippets",
        l = { "<cmd>lua require('luasnip').jump(1)<cr>", "➡️ Next Placeholder" },
        h = { "<cmd>lua require('luasnip').jump(-1)<cr>", "⬅️ Previous Placeholder" },
        c = { "<cmd>lua require('luasnip').change_choice(1)<cr>", "🔄 Change Choice" },
        e = { "<cmd>lua require('luasnip').expand()<cr>", "📝 Expand Snippet" },
      },
    })

    -- Register non-leader keybindings
    wk.register({
      ["[q"] = { "<cmd>cprev<cr>", "⬆️ Previous Quickfix" },
      ["]q"] = { "<cmd>cnext<cr>", "⬇️ Next Quickfix" },
      ["[c"] = { "Previous Git Hunk" },
      ["]c"] = { "Next Git Hunk" },
      ["<Tab>"] = { "<cmd>BufferLineCycleNext<cr>", "➡️ Next Buffer" },
      ["<S-Tab>"] = { "<cmd>BufferLineCyclePrev<cr>", "⬅️ Previous Buffer" },
      ["<S-h>"] = { "<cmd>BufferLineCyclePrev<cr>", "⬅️ Previous Buffer" },
      ["<S-l>"] = { "<cmd>BufferLineCycleNext<cr>", "➡️ Next Buffer" },
      ["<C-h>"] = { "<C-w>h", "⬅️ Go to Left Window" },
      ["<C-j>"] = { "<C-w>j", "⬇️ Go to Lower Window" },
      ["<C-k>"] = { "<C-w>k", "⬆️ Go to Upper Window" },
      ["<C-l>"] = { "<C-w>l", "➡️ Go to Right Window" },
      ["<C-Up>"] = { "<cmd>resize -2<cr>", "⬆️ Resize Window Up" },
      ["<C-Down>"] = { "<cmd>resize +2<cr>", "⬇️ Resize Window Down" },
      ["<C-Left>"] = { "<cmd>vertical resize -2<cr>", "⬅️ Resize Window Left" },
      ["<C-Right>"] = { "<cmd>vertical resize +2<cr>", "➡️ Resize Window Right" },
    })

    -- Visual mode keybindings
    wk.register({
      ["<"] = { "<gv", "⬅️ Indent Left" },
      [">"] = { ">gv", "➡️ Indent Right" },
      ["J"] = { ":m '>+1<CR>gv=gv", "⬇️ Move Text Down" },
      ["K"] = { ":m '<-2<CR>gv=gv", "⬆️ Move Text Up" },
      ["p"] = { '"_dP', "📋 Paste Without Yanking" },
    }, { mode = "v" })

  end
}

