
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
vim.o.spell = false
vim.o.spelllang = "en_gb"
vim.o.splitright = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard:append("unnamedplus")

--=== Setup lazy.nvim ===
require("lazy").setup({
	spec = {
		{ "rebelot/kanagawa.nvim", config = function() vim.cmd.colorscheme "kanagawa" end },
		{
			"nvim-telescope/telescope.nvim", tag = "0.1.8",
			dependencies = {"nvim-lua/plenary.nvim"}
		},
		{ "ThePrimeagen/vim-be-good" },
		{ "nvim-treesitter/nvim-treesitter" },
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' }
		},
		{ 'tpope/vim-fugitive' }
	},

	checker = {enabled = true},
})

local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		path_display = {"truncate"},
		mappings = {
			n = {
				["X"] = actions.delete_buffer,
			},
		},
	},
})

------------------------------- Custom Homepage -------------------------------

scale	  = 2.4
alignment = 1
vim.api.nvim_create_user_command("HP", function()
	vim.cmd("enew")
	vim.cmd("setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile")
	vim.cmd("setlocal nonumber norelativenumber nocursorline nospell")

	if vim.g.neovide then
		scale	  = 3.5
		alignment = 1.35
	end

	local banner = {
		" ██████╗ ██████╗ ███████╗ █████╗ ████████╗███████╗██████╗ ██╗   ██╗██╗███▅╗ ▅███╗",
		"▅▅╔════  ▅▅▅▅▅▅▃╗▅▅▅▅▅▅╗ ▅▅▅▅▅▅▅╗ ══▅▅╔══ ▅▅▅▅▅▅╗ ▅▅▅▅▅▅▃╗▅▅╗   ▅▅╗▅▅╗▅▅╔▅▅▅▅╔▅▅╗",
		"██║  ███╗██╔══██║██╔═══╝ ██╔══██║   ██║   ██╔═══╝ ██╔══██║ ██╗ ██╔╝██║██║╚██╔╝██║",
		"╚██████╔╝██║  ██║███████╗██║  ██║   ██║   ███████╗██║  ██║  ████╔╝ ██║██║ ╚═╝ ██║",
		" ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
		"The Greatest a Vim could be",
	}

	local win_width = vim.o.columns / alignment
	local pad_lines = math.floor((vim.o.lines - #banner) / scale)
	for _ = 1, pad_lines do
		vim.api.nvim_buf_set_lines(0, -1, -1, false, {""})
	end

	for _, line in ipairs(banner) do
		local line_width = vim.fn.strdisplaywidth(line)
		local padding = math.floor((win_width - line_width) / 2)
		local padded_line = string.rep(" ", padding) .. line
		vim.api.nvim_buf_set_lines(0, -1, -1, false, {padded_line})
	end

	vim.cmd("normal! gg")

	vim.api.nvim_create_autocmd("BufUnload", {
		buffer = 0,
		callback = function()
			vim.g.neovide_scale_factor = 0.8
		end,
	})

	vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", ":enew<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(0, "n", "i", ":enew<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(0, "n", "a", ":enew<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(0, "n", "o", ":enew<CR>", { noremap = true, silent = true })
	vim.api.nvim_create_autocmd("InsertEnter", {
		buffer = 0,
		once = true,
		callback = function()
			vim.cmd("enew")
		end
	})
end, {})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.g.neovide_scale_factor = 1.1
		vim.cmd("HP")
	end,
})

------------------------------- Custom lualine settings -------------------------------
local function file_size()
	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		return ""
	end

	local size_bytes = vim.fn.getfsize(filepath)
	local units = {"B", "KB", "GB"}
	local i = 1
	while size_bytes >= 1024 and i <= #units do
		size_bytes = size_bytes / 1024
		i = i + 1
	end

	return string.format('%.2f %s', size_bytes, units[i])
end

---------- Defining new theme

---------- Custom function for theming
local new_theme    = require('lualine.themes.auto')
new_theme.normal.a = new_theme.normal.a or {}
new_theme.normal.x = new_theme.normal.x or {}
new_theme.normal.z = new_theme.normal.z or {}

new_theme.insert   = new_theme.insert or {}
new_theme.insert.a = new_theme.insert.a or {}
new_theme.insert.x = new_theme.insert.x or {}
new_theme.insert.z = new_theme.insert.z or {}

new_theme.visual   = new_theme.visual or {}
new_theme.visual.a = new_theme.visual.a or {}
new_theme.visual.x = new_theme.visual.x or {}
new_theme.visual.z = new_theme.visual.z or {}

new_theme.replace   = new_theme.replace or {}
new_theme.replace.a = new_theme.replace.a or {}
new_theme.replace.x = new_theme.replace.x or {}
new_theme.replace.z = new_theme.replace.z or {}

color = function()
	local mode = vim.fn.mode()
	local mode_colors = {
		normal  = { fg = new_theme.normal.x.fg, bg = new_theme.normal.x.bg },
		insert  = { fg = new_theme.insert.x.fg, bg = new_theme.insert.x.bg },
		visual  = { fg = new_theme.visual.x.fg, bg = new_theme.visual.x.bg },
		replace = { fg = new_theme.replace.x.fg, bg = new_theme.replace.x.bg },
	}
	return mode_colors[mode] or mode_colors.normal -- Fallback to normal if mode not defined
end

---------- Coloring each section in each mode
---------- Section A
new_theme.normal.a.fg = "#FFFFFF"
new_theme.normal.a.bg = "#2A447A"

new_theme.insert.a.fg = "#FFFFFF"
new_theme.insert.a.bg = "#556D37"

new_theme.visual.a.fg = "#FFFFFF"
new_theme.visual.a.bg = "#4D3C67"

new_theme.replace.a.fg = "#FFFFFF"
new_theme.replace.a.bg = "#9B4008"

---------- Section X
new_theme.normal.x.fg = "#7B98D2"
new_theme.normal.x.bg = "#242433"

---------- Section Z
new_theme.normal.z.fg = "#000000"
new_theme.normal.z.bg = "#7B98D2"

new_theme.insert.z.fg = "#000000"
new_theme.insert.z.bg = "#92B368"

new_theme.visual.z.fg = "#000000"
new_theme.visual.z.bg = "#907BB2"

new_theme.replace.z.fg = "#000000"
new_theme.replace.z.bg = "#F79B63"

------------------------------- Plugin Bindings -------------------------------
require('lualine').setup {
	options = { theme = new_theme },
	sections = {
		lualine_x = {
			'encoding',
			'fileformat',
			{ 'filetype', color },
			file_size,
		},
		lualine_y = { '' },
		lualine_z = {
			'progress',
			'location',
		},
	},
}

local scope = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", function()
	scope.find_files({
		hidden = true,
		find_command = rg --files --hidden,
	})
end)

vim.keymap.set("n", "<leader>g", function()
	scope.live_grep()
end)

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

local ts_config = require("nvim-treesitter.configs")
ts_config.setup({
	ensure_installed = {"html", "css", "javascript", "lua", "python"},
	highlight = {enable = true},
	indent = {enable = true}
})
------------------------------- Global Bindings -------------------------------

---============ function to set keymaps ============---
local function split(istr, sep)
	if sep == nil then
		sep = "%s"
	end

	local t = {}
	for str in string.gmatch(istr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end

	return t
end

local set = function(lhs, rhs, modes)
	local mode_arr = split(modes, " ")
	for _, mode in ipairs(mode_arr) do
		vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
	end
end

---============ Search timer function ============---
local wait_map = function(key, modes)
	local mode_arr = split(modes, " ")
	for _, mode in ipairs(mode_arr) do
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

---=== Leader-key remaps ===---
set("<leader>s",	":w<CR>",		"n v")
set("<leader>q",	":q<CR>",		"n v")
set("<leader>r",	":so<CR>",		"n v")
set("<leader>L",	":Lazy<CR>",	"n v")
set("<leader>e",	'"+yiw',		"n v")
set("<leader>p",	'viw"+p',		"n v")
set("<leader>v",	"<C-v>",		"n v")
set("<leader>j",	"<C-^>",		"n v")
set("<leader>i",	"gt",			"n v")
set("<leader>t",	":term<CR>",	"n v")
set("<leader>n",	":tabnew<CR>",	"n v")
set("<leader>k",	"J",			"n v")
set("<leader>=",	"^V%=",			"n v")
set("<leader><Esc>",	"<C-\\><C-n>",	"t")
set("<leader>b",	":Telescope buffers<CR>",	"n v")
set("<leader>o",	":Telescope oldfiles<CR>",	"n v")

---=== Movement remaps ===---
set("k",	"kzz",		"n v")
set("j",	"jzz",		"n v")
set("K",	"<C-u>zz",	"n v")
set("J",	"<C-d>zz",	"n v")
set("a",	"i",		"n v")
set("A",	"I",		"n v")
set("i",	"a",		"n v")
set("I",	"A",		"n v")
set("H",	"^",		"n v")
set("L",	"$",		"n v")
set("L",	"$h",		"v")
set("n",	"nzz",		"n v")
set("N",	"Nzz",		"n v")
set("M",	"`",		"n v")
set("gg",	"ggzz",		"n v")
set("G",	"Gzz",		"n v")
set("<A-S-l>",	"<C-\\><C-n>gt",	"t n")

---=== Editing remaps ===---
set("<C-a>",		'ggVG',		"n v")
set("<leader>a", 	'ggVG"+y',	"n v")
set("y",			'"+y',		"n v")
set("d",			'"+d',		"n v")
set("s",			'"+s',		"n v")
set("U",			"<C-r>",	"n v")
set("dH",			"d^",		"n v")
set("<M-B>",		"<C-w>",	"i t")
set("<M-b>",		"<BS>",		"i t")
set("<C-v>",		"<C-r>+",	"i t")
set("p",			'"+p',		"n v")
set(";",			'^v$h"+y',	"n v")
set("<M-'>",		"`",		"i t")
set("d;",			"V%d",		"n v")

---=== Auto-containers ===---
set('"',	'""<Esc>ha',	"i t")
set("'",	"''<Esc>ha",	"i t")
set("{",	"{}<Esc>ha",	"i t")
set("(",	"()<Esc>ha",	"i t")
set("[",	"[]<Esc>ha",	"i t")
set("`",	"/*  */<Esc>hha","i")

---=== Searching remaps ===---
set('<M-;>', 	"%",		"n v")
set("<M-w>", 	"*zz",		"n v")
set("<Esc>", 	":noh<CR>",	"n v")

wait_map("f",				"n v")
wait_map("F",				"n v")

---=== Something to try out ===---
vim.cmd([[

]])
