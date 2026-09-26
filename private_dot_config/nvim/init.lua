-- ~/.config/nvim/init.lua

-- Set <space> as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignorecase = true

-- Yank/copy to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Cycle through tabs
vim.keymap.set("n", "<Tab>", "gt", { desc = "Next tab" })
vim.keymap.set("n", "<S-Tab>", "gT", { desc = "Previous tab" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure Plugins
require("lazy").setup({ { import = "plugins" } })
