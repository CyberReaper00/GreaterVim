
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
	vim.defer_fn(function()
	    vim.cmd("HP")
	end, 50)
    end,
})
