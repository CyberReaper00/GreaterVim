
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

require("telescope").setup({
    defaults = {
	path_display = {"truncate"},
    },
})

------------------------------- Custom Homepage -------------------------------
vim.api.nvim_create_user_command("HP", function()
    vim.cmd("enew")
    vim.cmd("setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile")
    vim.cmd("setlocal nonumber norelativenumber nocursorline nospell")

    local banner = {
	" ██████╗ ██████╗ ███████╗ █████╗ ████████╗███████╗██████╗ ██╗   ██╗██╗███▅╗ ▅███╗",
	"▅▅╔════  ▅▅▅▅▅▅▃╗▅▅▅▅▅▅╗ ▅▅▅▅▅▅▅╗ ══▅▅╔══ ▅▅▅▅▅▅╗ ▅▅▅▅▅▅▃╗▅▅╗   ▅▅╗▅▅╗▅▅╔▅▅▅▅╔▅▅╗",
	"██║  ███╗██╔══██║██╔═══╝ ██╔══██║   ██║   ██╔═══╝ ██╔══██║ ██╗ ██╔╝██║██║╚██╔╝██║",
	"╚██████╔╝██║  ██║███████╗██║  ██║   ██║   ███████╗██║  ██║  ████╔╝ ██║██║ ╚═╝ ██║",
	" ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
	"The Greatest a Vim could be",
	"", "", "", "", "", "", "", "", "", "", "", "", ""
    }

    local win_width = vim.o.columns / 1.35
    local pad_lines = math.floor((vim.o.lines - #banner) / 2)
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

------------------------------- Custom lualine function -------------------------------
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
local new_theme = require('lualine.themes.auto')
new_theme.normal.a = new_theme.normal.a or {}
new_theme.normal.x = new_theme.normal.x or {}
new_theme.normal.z = new_theme.normal.z or {}

new_theme.insert = new_theme.insert or {}
new_theme.insert.a = new_theme.insert.a or {}
new_theme.insert.x = new_theme.insert.x or {}
new_theme.insert.z = new_theme.insert.z or {}

new_theme.visual = new_theme.visual or {}
new_theme.visual.a = new_theme.visual.a or {}
new_theme.visual.x = new_theme.visual.x or {}
new_theme.visual.z = new_theme.visual.z or {}

new_theme.replace = new_theme.replace or {}
new_theme.replace.a = new_theme.replace.a or {}
new_theme.replace.x = new_theme.replace.x or {}
new_theme.replace.z = new_theme.replace.z or {}

color = function()
  local mode = vim.fn.mode()
  local mode_colors = {
    normal = { fg = new_theme.normal.x.fg, bg = new_theme.normal.x.bg },
    insert = { fg = new_theme.insert.x.fg, bg = new_theme.insert.x.bg },
    visual = { fg = new_theme.visual.x.fg, bg = new_theme.visual.x.bg },
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

local search_params = function(filenames, dirnames)
    local args = {"fd", "--type", "f", "--hidden", "--no-ignore"}

    for _, name in ipairs(filenames) do
	table.insert(args, "--type")
	table.insert(args, "f")
	table.insert(args, "--exclude")
	table.insert(args, name)
    end
    for _, name in ipairs(dirnames) do
	table.insert(args, "--type")
	table.insert(args, "d")
	table.insert(args, "--exclude")
	table.insert(args, name)
    end
    return args
end

local exc_dirs = {".cache", ".local", ".git", "firefox", "Pictures", "pythonProject", ".ollama", "Music", "go/pkg", "Documents/Veracity Files/Documents"}
local exc_files = {".gitignore", ".gitconfig"}

vim.keymap.set("n", "<leader>f", function()
    scope.find_files({
	hidden = false,
	find_command = search_params(exc_files, exc_dirs)
    })
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

---------------- Set keymap function ----------------
local m0 = {"n", "v"}
local m1 = {"t", "i"}

local nmap = function(lhs, rhs, type)
    if type == 0 then
	for _, mode in ipairs(m0) do
	    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
	end
    elseif type == 1 then
	for _, mode in ipairs(m1) do
	    vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true })
	end
    end
end

---------------- Search timer function ----------------
local wait_map = function(key)
    for _, mode in ipairs(m0) do
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
nmap("<leader>s", ":w<CR>", 0)
nmap("<leader>q", ":q<CR>", 0)
nmap("<leader>r", ":source %<CR>", 0)
nmap("<leader>L", ":Lazy<CR>", 0)
nmap("<leader>e", '"+yiw', 0)
nmap("<leader>p", 'viw"+p', 0)
nmap("<leader>l", "<C-v>", 0)
nmap("<leader>j", "<C-^>", 0)
nmap("<leader>i", "gt", 0)
nmap("<leader>w", "<C-w>h", 0)
nmap("<leader>o", "<C-w>l", 0)
nmap("<leader>t", ":term<CR>", 0)
nmap("<leader>S", ":30vnew<CR>", 0)
nmap("<leader>h", ":vert resize 30<CR>", 0)
nmap("<leader>n", ":tabnew<CR>", 0)
nmap("<leader>k", "J", 0)
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>")

--=== Movement remaps ===
nmap("k","kzz", 0)
nmap("j", "jzz", 0)
nmap("K", "<C-u>zz", 0)
nmap("J", "<C-d>zz", 0)
nmap("a", "i", 0)
nmap("A", "I", 0)
nmap("i", "a", 0)
nmap("I", "A", 0)
nmap("H", "^", 0)
nmap("L", "$", 0)
vim.keymap.set("v", "L", "$h")
nmap("n", "nzz", 0)
nmap("N", "Nzz", 0)
nmap("M", "`", 0)
nmap("gg", "ggzz", 0)
nmap("G", "Gzz", 0)

--=== Editing remaps ===
nmap("<C-a>", 'ggVG', 0)
nmap("<leader>a", 'ggVG"+y', 0)
nmap("y", '"+y', 0)
nmap("d", '"+d', 0)
nmap("s", '"+s', 0)
nmap("U", "<C-r>", 0)
nmap("dH", "d^", 0)
nmap("<M-B>", "<C-w>", 1)
nmap("<M-b>", "<BS>", 1)
nmap("<C-v>", "<C-r>+", 1)
nmap("p", '"+p', 0)
nmap(";", '^v$h"+y', 0)
nmap("<M-'>", "`", 1)

--=== Auto-containers ===
nmap('"', '""<Esc>ha', 1)
nmap("'", "''<Esc>ha", 1)
nmap("{", "{}<Esc>ha", 1)
nmap("(", "()<Esc>ha", 1)
nmap("[", "[]<Esc>ha", 1)

--=== Searching remaps ===
nmap("<Esc>", ":noh<CR>", 0)
nmap("<A-S-w>", "*", 0)
nmap('<M-;>', "%", 0)
wait_map("f")
wait_map("F")

--=== Something to try out ===
vim.cmd([[

]])
