
------------------------------- Lazy.nvim Config -------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
	vim.api.nvim_echo({
	    { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
	    { out, "WarningMsg" },
	    { "\nPress any key to exit..." },
	}, true, {})
	vim.fn.getchar()
	os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Leader-key initialization
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Accessibilty settings
vim.o.ignorecase = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
	{"rebelot/kanagawa.nvim", config = function() vim.cmd.colorscheme "kanagawa" end},
	{
	    'nvim-telescope/telescope.nvim', tag = '0.1.8',
	    dependencies = {'nvim-lua/plenary.nvim'}
	}
    },

    checker = {enabled = true},
})

require('telescope').setup({
    defaults = {
	path_display = {'truncate'},
    },
})

------------------------------- PLugin Bindings -------------------------------

local aa = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', aa.find_files, {})
vim.keymap.set('n', '<leader>g', aa.live_grep, {})

--[[
    local ts_config = require('nvim-treesitter.configs')
    ts_config.setup({
    ensure_installed = {'html', 'css', 'javascript', 'lua', 'python'},
    highlight = {enable = true},
    indent = {enable = true}
})
]]--
------------------------------- Global Bindings -------------------------------

local modes = {'n', 'v'}

local nmap = function(lhs, rhs)
    for _, mode in ipairs(modes) do
	vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
    end
end

-- Leader-key remaps
nmap('<leader>s', ':w<CR>')
nmap('<leader>q', ':q<CR>')
nmap('<leader>r', ':source %<CR>')
nmap('<leader>l', ':Lazy<CR>')
nmap('<leader>w', 've"+y')
nmap('<leader>W', 've"+gP')

-- Movement remaps
nmap('j','kzz')
nmap('k', 'jzz')
nmap('a', 'i')
nmap('A', 'I')
nmap('i', 'a')
nmap('I', 'A')
nmap('H', '^')
nmap('L', '$')
nmap('J', '<C-u>zz')
nmap('K', '<C-d>zz')
nmap('n', 'Nzz')
nmap('N', 'nzz')
nmap('M', '`')
nmap('gg', 'ggzz')
nmap('G', 'Gzz')

-- Editing remaps
nmap('<C-a>', 'ggVG"+y')
nmap(';', 'R')
nmap('y', '"+y')
nmap('d', '"+d')
nmap('s', '"+s')

-- Searching remaps
nmap('<Esc>', ':noh<CR>')
nmap('<A-S-w>', '<S-*>')
nmap('"', '%')
