return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })

    -- Terminal keymaps
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    -- Custom terminal functions
    local Terminal = require('toggleterm.terminal').Terminal

    -- Horizontal terminal
    local horizontal_term = Terminal:new({
      direction = "horizontal",
      count = 1,
    })

    function _HORIZONTAL_TOGGLE()
      horizontal_term:toggle(15)
    end

    -- Vertical terminal
    local vertical_term = Terminal:new({
      direction = "vertical",
      count = 2,
    })

    function _VERTICAL_TOGGLE()
      vertical_term:toggle(vim.o.columns * 0.4)
    end

    -- Float terminal
    local float_term = Terminal:new({
      direction = "float",
      count = 3,
    })

    function _FLOAT_TOGGLE()
      float_term:toggle()
    end

    -- Keymaps for different terminal types
    vim.keymap.set("n", "<leader>th", "<cmd>lua _HORIZONTAL_TOGGLE()<CR>", { desc = "Horizontal Terminal" })
    vim.keymap.set("n", "<leader>tv", "<cmd>lua _VERTICAL_TOGGLE()<CR>", { desc = "Vertical Terminal" })
    vim.keymap.set("n", "<leader>tf", "<cmd>lua _FLOAT_TOGGLE()<CR>", { desc = "Float Terminal" })
  end,
}
