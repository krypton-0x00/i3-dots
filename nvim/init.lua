-- Leader key must be set before plugins
vim.g.mapleader = " "

-- Core config
require("core.options")
require("core.keymaps")

-- Plugins
require("plugins")

