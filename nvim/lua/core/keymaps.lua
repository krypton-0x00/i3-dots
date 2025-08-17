local map = vim.keymap.set

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, noremap = true, desc = "Toggle file tree" })

-- Save & quit
map("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { silent = true, desc = "Quit" })
map("n", "<leader>x", ":x<CR>", { silent = true, desc = "Save and quit" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Window resizing
map("n", "<C-Up>", ":resize -2<CR>", { silent = true, desc = "Resize window up" })
map("n", "<C-Down>", ":resize +2<CR>", { silent = true, desc = "Resize window down" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true, desc = "Resize window left" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true, desc = "Resize window right" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move text up and down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move text down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move text up" })

-- Clear search highlighting
map("n", "<leader>h", ":nohlsearch<CR>", { silent = true, desc = "Clear search highlight" })

-- Better paste
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Buffer navigation with Tab
map("n", "<Tab>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Next buffer" })
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Previous buffer" })

-- Quick fix list
map("n", "<leader>co", ":copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix list" })
map("n", "]q", ":cnext<CR>", { desc = "Next quickfix item" })
map("n", "[q", ":cprev<CR>", { desc = "Previous quickfix item" })

-- Split windows
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

-- Theme switching
map("n", "<leader>tt", function()
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
  print("Switched to " .. themes[next_index])
end, { desc = "Toggle themes" })

