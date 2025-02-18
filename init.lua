
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

-- Accessibility settings
vim.o.ignorecase = true
vim.o.spell = true
vim.o.spelllang = 'en_gb'
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

------------------------------- Plugin Bindings -------------------------------

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
nmap('<leader>v', '<C-v>')

-- Movement remaps
nmap('k','kzz')
nmap('j', 'jzz')
nmap('K', '<C-u>zz')
nmap('J', '<C-d>zz')
nmap('a', 'i')
nmap('A', 'I')
nmap('i', 'a')
nmap('I', 'A')
nmap('H', '^')
nmap('L', '$')
nmap('n', 'nzz')
nmap('N', 'Nzz')
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

-- LaTeX Config
vim.cmd([[
  " Greek letters
  iabbrev _alpha α
  iabbrev _beta β
  iabbrev _gamma γ
  iabbrev _delta δ
  iabbrev _epsilon ε
  iabbrev _zeta ζ
  iabbrev _eta η
  iabbrev _theta θ
  iabbrev _iota ι
  iabbrev _kappa κ
  iabbrev _lambda λ
  iabbrev _mu μ
  iabbrev _nu ν
  iabbrev _xi ξ
  iabbrev _pi π
  iabbrev _rho ρ
  iabbrev _sigma σ
  iabbrev _tau τ
  iabbrev _upsilon υ
  iabbrev _phi φ
  iabbrev _chi χ
  iabbrev _psi ψ
  iabbrev _omega ω

  " Capital Greek letters
  iabbrev _Gamma Γ
  iabbrev _Delta Δ
  iabbrev _Theta Θ
  iabbrev _Lambda Λ
  iabbrev _Xi Ξ
  iabbrev _Pi Π
  iabbrev _Sigma Σ
  iabbrev _Upsilon Υ
  iabbrev _Phi Φ
  iabbrev _Psi Ψ
  iabbrev _Omega Ω

  " Common math symbols
  iabbrev _infty ∞
  iabbrev _partial ∂
  iabbrev _nabla ∇
  iabbrev _pm ±
  iabbrev _times ×
  iabbrev _div ÷
  iabbrev _cdot ⋅
  iabbrev _leq ≤
  iabbrev _geq ≥
  iabbrev _neq ≠
  iabbrev _approx ≈
  iabbrev _propto ∝
  iabbrev _forall ∀
  iabbrev _exists ∃
  iabbrev _emptyset ∅
  iabbrev _in ∈
  iabbrev _notin ∉
  iabbrev _subset ⊂
  iabbrev _subseteq ⊆
  iabbrev _supset ⊃
  iabbrev _supseteq ⊇
  iabbrev _cup ∪
  iabbrev _cap ∩
  iabbrev _setminus ∖
  iabbrev _Rightarrow ⇒
  iabbrev _Leftarrow ⇐
  iabbrev _Leftrightarrow ⇔
  iabbrev _to →
  iabbrev _gets ←
  iabbrev _iff ⇔

  " Miscellaneous symbols
  iabbrev _degree °
  iabbrev _ell ℓ
  iabbrev _angle ∠
  iabbrev _therefore ∴
  iabbrev _because ∵
  iabbrev _sqrt √
  iabbrev _sum ∑
  iabbrev _prod ∏
  iabbrev _int ∫
  iabbrev _oint ∮
]])

