
---============================ Global Options ============================---

--=== Leader-key initialization ===
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--=== Accessibility settings ===
vim.o.ignorecase = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.o.spell = false
vim.o.spelllang = "en_gb"
vim.o.splitright = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.clipboard:append("unnamedplus")
vim.opt.keywordprg = ":h"
vim.opt.shell = '/nix/store/avwdl5bnf4xl7nf60vrxxs5q7z39l02k-powershell-7.5.1/bin/pwsh'
vim.opt.listchars = "space:|,tab:▶∘"

---============================ Lazy.nvim Config ============================---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

--=== Setup lazy.nvim ===
require("lazy").setup({
	spec = {
		{
			"shaunsingh/nord.nvim", config = function() vim.cmd.colorscheme "nord" end
		}, {
			"nvim-telescope/telescope.nvim", tag = "0.1.8",
			dependencies = {"nvim-lua/plenary.nvim"}
		}, {
			"ThePrimeagen/vim-be-good"
		}, {
			"nvim-treesitter/nvim-treesitter"
		}, {
			'nvim-lualine/lualine.nvim',
			dependencies = {'nvim-tree/nvim-web-devicons'}
		}, {
			'tpope/vim-fugitive'
		}
	},

	checker = {enabled = true},
})

---============================ Custom Splash Screen ============================---

scale	  = 2.4
alignment = 1
local function command(cmd)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd, true, true, true), 'n', false)
end
timer = vim.loop.new_timer()

local function open_setup(type)
	if type == 'terminal' then
		command(":enew<cr>")
		command(":term<cr>")
		command(":tabnew<cr>")
		vim.api.nvim_feedkeys('gt', 'n', false)
		vim.api.nvim_feedkeys('i', 'n', false)

	elseif type == 'new_file' then
		command(":enew<cr>")
		command(":term<cr>")
		command(":tabnew<cr>")
		timer:start(100, 0, vim.schedule_wrap(function()
			vim.cmd("Telescope oldfiles")
		end))
	end

	vim.cmd("set laststatus=3")
end

vim.api.nvim_create_user_command("SS", function()
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

	vim.api.nvim_create_autocmd("BufUnload", {
		buffer = 0,
		callback = function()
			vim.g.neovide_scale_factor = 0.8
		end,
	})

	vim.cmd("normal! gg")

	vim.keymap.set("n", "i", function() open_setup('terminal') end, { buffer = 0, noremap = true, silent = true })
	vim.keymap.set("n", "<Esc>", function() open_setup('new_file') end, { buffer = 0, noremap = true, silent = true })
end, {})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.g.neovide_scale_factor = 1.1
		vim.cmd("SS")
		vim.cmd("set laststatus=0")
	end,
})

---============================ Custom lualine settings ============================---
local function file_size()
	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		return ""
	end

	local size_bytes = vim.fn.getfsize(filepath)
	local units = {"B", "KiB", "GiB"}
	local i = 1
	while size_bytes >= 1024 and i <= #units do
		size_bytes = size_bytes / 1024
		i = i + 1
	end

	return string.format('%.2f %s', size_bytes, units[i])
end

---============================ Plugin Bindings ============================---
----------------- Lualine
require('lualine').setup {
	options = { theme = 'nord' },
	sections = {
		lualine_x = { 'encoding', 'fileformat', { 'filetype', color }, file_size, },
		lualine_y = { '' },
		lualine_z = { 'progress', 'location', },
	},
}

-- Nord theme config
vim.g.nord_bold = true
vim.g.nord_italic = false
vim.g.nord_borders = true
vim.g.nord_contrast = true
vim.g.nord_disable_background = false
vim.g.nord_uniform_diff_background = true

-- Loading colorscheme
require('nord').set()

	-- black				="#2E3440",
	-- dark_gray			="#3B4252",
	-- gray					="#434C5E",
	-- light_gray			="#4C566A",
	-- light_gray_bright	="#616E88",
	-- darkest_white		="#D8DEE9",
	-- darker_white			="#E5E9F0",
	-- white				="#ECEFF4",
	-- teal					="#8FBCBB",
	-- off_blue				="#88C0D0",
	-- glacier				="#81A1C1",
	-- blue					="#5E81AC",
	-- red					="#BF616A",
	-- orange				="#D08770",
	-- yellow				="#EBCB8B",
	-- green				="#A3BE8C",
	-- purple				="#B48EAD",
	-- none					="NONE",

vim.cmd('colorscheme nord')
vim.api.nvim_set_hl(0, "Normal", { fg = "#D8DEE9", bg = "#2E3440" })
vim.api.nvim_set_hl(0, "String", { ctermfg = 0, fg = "#81C1D1" })
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#ffffff", bg = "#d08770" })

----------------- Get last character position in selection
-- local function get_max_name_column()
--     -- Get the start and end line numbers of the last visual selection
--     local start_line = vim.fn.line("'<")
--     local end_line = vim.fn.line("'>")
--     local max_col = 0
--
--     -- Iterate through each line in the selection
--     for i = start_line, end_line do
--         local line_text = vim.fn.getline(i)
--
--         -- Find the position (byte index) of the first whitespace after the name
--         -- '\S\s\+' finds a non-whitespace followed by one or more whitespace
--         local end_of_name_idx = vim.fn.match(line_text, '\\S\\s\\+')
--
--         -- If a match is found (end_of_name_idx is not -1)
--         if end_of_name_idx > -1 then
--             -- The column we want is 1 character past the end of the name
--             local byte_pos = end_of_name_idx + 1
--
--             -- Convert the byte position to a screen (virtual) column number
--             local virt_col = vim.fn.virtcol({i, byte_pos})
--
--             if virt_col > max_col then
--                 max_col = virt_col
--             end
--         end
--     end
--
--     -- Display the final result
--     print("Max Column for Name End: " .. max_col)
-- end
-- vim.api.nvim_create_user_command('MaxCol', get_max_name_column, {})

----------------- Telescope
local actions = require("telescope.actions")
require("telescope").setup({
	defaults = {
		path_display = {"truncate"},
		mappings = {
			n = {
				["dd"] = actions.delete_buffer,
			},
		},
	},
})

local scope = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", function()
	scope.find_files({
		hidden = true,
		find_command = {"fd", "-H", "-p", "--no-ignore", ".", "nixos", "Documents"}
	})
end)

vim.keymap.set("n", "<leader>g", function()
	scope.live_grep()
end)

----------------- Treesitter
local ts_config = require("nvim-treesitter.configs")
ts_config.setup({
	ensure_installed = {"html", "css", "javascript", "lua", "python"},
	highlight = {enable = true},
	indent = {enable = true}
})

---============================ Global Bindings ============================---

---============ function to set keymaps ============---
local function split(istr, sep)
	if sep == nil then sep = "%s" end

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
			timer:start(500, 0, vim.schedule_wrap(function()
				vim.api.nvim_feedkeys("\n", mode, true) -- Press Enter after 500ms
			end))
		end, { noremap = true, silent = true })
	end
end

---=== Netrw remaps ===---
-- vim.cmd("au FileType netrw nnoremap <buffer> <Leader>a g:netrw-reverse")

---=== Leader-key remaps ===---
set("<leader>s",	":w<cr>",		"n v")
set("<leader>q",	":q<cr>",		"n v")
set("<leader>r",	":so<cr>",		"n v")
set("<leader>L",	":Lazy<cr>",	"n v")
set("<leader>e",	'"+yiw',		"n v")
set("<leader>p",	'viw"+p',		"n v")
set("<leader>v",	"<C-v>",		"n v")
set("<leader>j",	"<C-^>",		"n v")
set("<leader>t",	":term<cr>",	"n v")
set("<leader>n",	":tabnew<cr>",	"n v")
set("<leader>k",	"J",			"n v")
set("<leader>=",	"^V%=",			"n v")
set("<leader>b",	":Telescope buffers<cr><esc>",	"n v")
set("<leader>o",	":Telescope oldfiles<cr>",	"n v")

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
set("L",	"$",		"n")
set("L",	"$h",		"v")
set("n",	"nzz",		"n v")
set("N",	"Nzz",		"n v")
set("M",	"`",		"n v")
set("gg",	"ggzz",		"n v")
set("G",	"Gzz",		"n v")
set("<c-k>","K",	 	"n v")
set("<a-j>","ddp",		"n")
set("<a-k>","ddkP",		"n")

---=== Editing remaps ===---
set("<C-S-a>",		'ggVG',		"n v")
set("<leader>a", 	'ggVG"+y',	"n v")
set("y",			'"+y',		"n v")
set("d",			'"+d',		"n v")
set("s",			'"+s',		"n v")
set("U",			"<C-r>",	"n v")
set("dH",			"d^",		"n v")
set("<A-B>",		"<C-w>",	"i t")
set("<A-b>",		"<BS>",		"i t")
set("p",			'"+p',		"n v")
set("<A-'>",		"`",		"i t")
set("<Tab>",		">>",		"n")
set("<S-Tab>",		"<<",		"n")
set("<Tab>",		">",		"v")
set("<S-Tab>",		"<",		"v")
set("<a-n>",		"<cr>",		"v i n t")

---=== Powermaps ===---
vim.g.prev_tab = nil
function recent_tab()
	local current_tab = vim.api.nvim_get_current_tabpage()

	if vim.g.prev_tab ~= nil then
		vim.api.nvim_set_current_tabpage(vim.g.prev_tab)
		vim.g.prev_tab = current_tab
	else
		vim.g.prev_tab = current_tab
		vim.api.nvim_feedkeys('gt', 'n', false)
		vim.api.nvim_feedkeys('i', 'n', false)
	end
end

set(";",	'^v$h"+y',	"n v")
set("d;",	"V%d",		"n v")
set("v;",	"V%y",		"n v")
set("c;",	function() vim.api.nvim_feedkeys("v%gc", "v", false) end, "n v")
set("<A-l>", recent_tab,	"t i n")
set("<c-;>", "<esc>",	 	"i")
set("<c-;>", "<C-\\><C-n>",	"t")

---=== Auto-containers ===---
set('"',	'""<Esc>ha',	"i")
set("'",	"''<Esc>ha",	"i")
set("fjfj",	"{}<Esc>ha",	"i")
set("(",	"()<Esc>ha",	"i")
set("[",	"[]<Esc>ha",	"i")
set("`",	"/*  */<Esc>hhha","i")

---=== Searching remaps ===---
set("<a-;>", 	"%",		"n v")
set("<a-w>", 	"*zz",		"n v")
set("<a-s-w>", 	"#zz",		"n v")

wait_map("f",				"n v")
wait_map("F",				"n v")

---=== HTML autotags ===---
local function html_tag(cmd, open, close, bufnr)
	local exceptions = {"h1", "h2", "h3", "h4", "<a", "<p", "span"}
	local is_exception = false

	for _, tag in ipairs(exceptions) do
		if string.find(open, tag) then
			is_exception = true
		end
	end

	if close == "" then
		vim.keymap.set("i", cmd, open .."<esc>i ",
		{ noremap = true, silent = true, buffer = bufnr })

	elseif is_exception then
		vim.keymap.set("i", cmd, open .."".. close .."<esc>F<i",
		{ noremap = true, silent = true, buffer = bufnr })

	else
		vim.keymap.set("i", cmd, open .."<esc>o<esc>s".. close .."<esc>O",
		{ noremap = true, silent = true, buffer = bufnr })
	end
end

local function meta()
	local filetype = vim.bo.filetype
	if filetype == "html" then
		local keys = vim.api.nvim_replace_termcodes("<meta charset='UTF-8'><esc>o<meta name='viewport' content='width=device-width, initial-scale=1.0'><esc>", true, true, true)
		vim.api.nvim_feedkeys(keys, "n", false)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "html",
	callback = function(ev)
		--------------- Top Hats
		html_tag("--hl", "<html>", "</html>", ev.buf)
		html_tag("--hd", "<head>", "</head>", ev.buf)
		set("--ma", meta, "i", ev.buf)
		html_tag("--tt", "<title>", "</title>", ev.buf)
		html_tag("--se", "<style>", "</style>", ev.buf)

		--------------- Body builders
		html_tag("--by", "<body>", "</body>", ev.buf)
		html_tag("--nv", "<nav>", "</nav>", ev.buf)
		html_tag("--dv", "<div>", "</div>", ev.buf)
		html_tag("--p", "<p>", "</p>", ev.buf)
		html_tag("--a", "<a href=''>", "</a>", ev.buf)
		html_tag("--ig", "<img src=''>", "", ev.buf)
		html_tag("--it", "<input class='' type='' value=''>", "", ev.buf)
		html_tag("--hr", "<header>", "</header>", ev.buf)
		html_tag("--h1", "<h1>", "</h1>", ev.buf)
		html_tag("--h2", "<h2>", "</h2>", ev.buf)
		html_tag("--h3", "<h3>", "</h3>", ev.buf)
		html_tag("--h4", "<h4>", "</h4>", ev.buf)
		html_tag("--sn", "<span>", "</span>", ev.buf)
	end,
})
