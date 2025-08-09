local map = vim.keymap.set

-- File tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true, noremap = true })

-- Save & quit
map("n", "<leader>w", ":w<CR>", { silent = true })
map("n", "<leader>q", ":q<CR>", { silent = true })

