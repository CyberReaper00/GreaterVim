
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

--=== Leader-key initialization ===
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--=== Accessibility settings ===
vim.o.ignorecase = true
vim.o.spell = true
vim.o.spelllang = "en_gb"
vim.o.splitright = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true

--=== Setup lazy.nvim ===
require("lazy").setup({
    spec = {
	{"rebelot/kanagawa.nvim", config = function() vim.cmd.colorscheme "kanagawa" end},
	{
	    "nvim-telescope/telescope.nvim", tag = "0.1.8",
	    dependencies = {"nvim-lua/plenary.nvim"}
	},
	{"ThePrimeagen/vim-be-good"}
    },

    checker = {enabled = true},
})

require("telescope").setup({
    defaults = {
	path_display = {"truncate"},
    },
})

------------------------------- Plugin Bindings -------------------------------

local aa = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", aa.find_files, {})
vim.g.neovide_scale_factor = 1.0

vim.keymap.set("n", "<C-=>", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>l", true, false, true), "n", false)
    vim.cmd("vert resize 30")
 end)

vim.keymap.set("n", "<C-->", function()
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>l", true, false, true), "n", false)
    vim.cmd("vert resize 20")
 end)

--[[
    local ts_config = require("nvim-treesitter.configs")
    ts_config.setup({
    ensure_installed = {"html", "css", "javascript", "lua", "python"},
    highlight = {enable = true},
    indent = {enable = true}
})
]]--
------------------------------- Global Bindings -------------------------------

---------------- Set keymap function ----------------
local modes = {"n", "v"}

local nmap = function(lhs, rhs)
    for _, mode in ipairs(modes) do
	vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
    end
end

---------------- Search timer function ----------------
local wait_map = function(key)
    for _, mode in ipairs(modes) do
	vim.keymap.set(mode, key, function()
	    if key == "f" then
		vim.api.nvim_feedkeys("/", mode, true)
	    elseif key == "F" then
		vim.api.nvim_feedkeys("?", mode, true)
	    end

	  -- Start a timer in the background
	  local timer = vim.loop.new_timer()
	  timer:start(500, 0, vim.schedule_wrap(function()
	    vim.api.nvim_feedkeys("\n", mode, true) -- Press Enter after 500ms
	  end))
	end, { noremap = true, silent = true })
    end
end

--=== Leader-key remaps ===
nmap("<leader>s", ":w<CR>")
nmap("<leader>q", ":q<CR>")
nmap("<leader>r", ":source %<CR>")
nmap("<leader>l", ":Lazy<CR>")
nmap("<leader>e", '"+yiw')
nmap("<leader>p", 'viw"+p')
nmap("<leader>v", "<C-v>")
nmap("<leader>j", "<C-^>")
nmap("<leader>i", "gt")
nmap("<leader>w", "<C-w>h")
nmap("<leader>o", "<C-w>l")
nmap("<leader>t", ":term<CR>")
nmap("<leader>S", ":30vnew<CR>")
nmap("<leader>h", ":vert resize 30<CR>")
nmap("<leader>n", ":tabnew<CR>")
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>")

--=== Movement remaps ===
nmap("k","kzz")
nmap("j", "jzz")
nmap("K", "<C-u>zz")
nmap("J", "<C-d>zz")
nmap("a", "i")
nmap("A", "I")
nmap("i", "a")
nmap("I", "A")
nmap("H", "^")
nmap("L", "$")
vim.keymap.set("v", "L", "$h")
nmap("n", "nzz")
nmap("N", "Nzz")
nmap("M", "`")
nmap("gg", "ggzz")
nmap("G", "Gzz")

--=== Editing remaps ===
nmap("<C-a>", 'ggVG')
nmap("<leader>a", 'ggVG"+y')
nmap(";", "R")
nmap("y", '"+y')
nmap("d", '"+d')
nmap("s", '"+s')
nmap("U", "<C-r>")
nmap("dH", "d^")
vim.keymap.set("i", "<M-B>", "<C-w>")
vim.keymap.set("i", "<M-b>", "<BS>")
vim.keymap.set("t", "<M-B>", "<C-w>")
vim.keymap.set("t", "<M-b>", "<BS>")
vim.keymap.set("t", "<M-b>", "<BS>")
vim.keymap.set("i", "<C-v>", "<C-r>+")
nmap("p", '"+p')

--=== Searching remaps ===
nmap("<Esc>", ":noh<CR>")
nmap("<A-S-w>", "*")
nmap('"', "%")
wait_map("f")
wait_map("F")

--=== Something to try out ===
vim.cmd([[

]])
