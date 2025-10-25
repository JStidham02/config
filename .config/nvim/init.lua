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

-- Configure plugins
require("lazy").setup({
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  -- Optional but recommended for better performance
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "lua", "vim", "vimdoc", "cpp", "rust", "verilog", "python" },
        highlight = { enable = true },
      })
    end,
  },
})

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })

-- Set leader key (default is \)
vim.g.mapleader = ' '

vim.opt.number = true

vim.keymap.set({'n', 'i', 'v'}, '<ScrollWheelUp>', '<Up>')
vim.keymap.set({'n', 'i', 'v'}, '<ScrollWheelDown>', '<Down>')
vim.keymap.set({'n', 'i', 'v'}, '<ScrollWheelLeft>', '<Left>')
vim.keymap.set({'n', 'i', 'v'}, '<ScrollWheelRight>', '<Right>')
vim.cmd('colorscheme desert256')

vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.tabstop = 4           -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4        -- Number of spaces for indentation
vim.opt.softtabstop = 4       -- Number of spaces for <Tab> key

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    -- Skip for markdown files
    if vim.bo.filetype == "markdown" then
      return
    end
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
})
