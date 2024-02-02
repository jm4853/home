vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.cindent = false
vim.opt.smartindent = false
vim.opt.showcmd = true
vim.api.nvim_command('filetype indent off')
vim.api.nvim_command('syntax on')
vim.api.nvim_command('hi Visual cterm=NONE    ctermbg=cyan  ctermfg=black')
vim.api.nvim_command('hi Search cterm=reverse ctermbg=black ctermfg=yellow')
vim.api.nvim_command('let mapleader = " "')
vim.api.nvim_command('map <leader>\\ :noh<CR>')
