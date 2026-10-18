-- Standard Neovim keymap function
local set = vim.keymap.set

-- Leader key, used for many keybindings
vim.g.mapleader = " "

--------------------------------------------------------------------------------
-- General Mappings
--------------------------------------------------------------------------------

-- Escape mappings
set({ "i", "v" }, "jk", "<Esc>", { desc = "Escape mode" })
set({ "i", "v" }, "kj", "<Esc>", { desc = "Escape mode" })
set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear search highlight" })

-- Treesitter node selection (built-in `an` / `in`)
set("n", "<CR>", "van", { remap = true, desc = "Select treesitter node" })
set("x", "<CR>", "an", { remap = true, desc = "Expand selection" })

-- Save and Quit
set("n", "<C-d>", "viw", { desc = "Select word" })
set("n", "<C-s>", "<cmd>update<cr>", { desc = "Save file" })
set({ "v", "i" }, "<C-s>", "<Esc><cmd>update<cr>", { desc = "Save file" })
set("n", "<leader>s", "<cmd>update<cr>", { desc = "Save file" })
set("n", "<leader>q", "<cmd>q<cr>", { desc = "Close current window" })

-- Buffer management
set("n", "<leader>w", function()
	Snacks.bufdelete()
end, { desc = "Close current buffer without closing window" })

-- Line numbers toggle
set("n", "<F4>", function()
	vim.opt.number = not vim.opt.number:get()
	if vim.opt.number:get() then
		vim.opt.relativenumber = not vim.opt.relativenumber:get()
	end
end, { desc = "Toggle line numbers (Normal/Relative/None)" })

-- Run current file
set("n", "<F5>", function()
	Snacks.terminal.open('"./' .. vim.fn.expand("%:t") .. '"', { cwd = vim.fn.expand("%:p:h"), auto_close = false })
end, { desc = "Run current file in terminal" })

set("n", "<leader><F5>", '<cmd>!cd "%:p:h"; chmod +x "%:t"; "./%:t"<cr>', { desc = "Make executable and run" })

-- System interaction
set("n", "<leader>p", function() Snacks.picker.commands() end, { desc = "Command Palette" })
set("n", "<leader>k", function() Snacks.picker.keymaps() end, { desc = "Keymaps Palette" })
set("n", "<F1>", function() Snacks.picker.commands() end, { desc = "Command Palette" })
set("i", "<C-z>", "<C-o><C-z>", { desc = "Suspend Neovim from insert mode" })
set("n", "Q", "<nop>", { desc = "Disable Ex mode" })

--------------------------------------------------------------------------------
-- Navigation
--------------------------------------------------------------------------------

-- Move cursor over wrapped display lines
set("n", "<up>", "g<up>", { desc = "Move up over wrapped lines" })
set("n", "<down>", "g<down>", { desc = "Move down over wrapped lines" })
set("i", "<up>", "<C-o>g<up>", { desc = "Move up over wrapped lines" })
set("i", "<down>", "<C-o>g<down>", { desc = "Move down over wrapped lines" })

-- Switch between buffers
set("n", "ä", "<cmd>bnext<cr>", { desc = "Next buffer" })
set("n", "ö", "<cmd>bprev<cr>", { desc = "Previous buffer" })

-- Switch between tabs
set("n", "Ä", "<cmd>tabnext<cr>", { desc = "Next tab" })
set("n", "Ö", "<cmd>tabprev<cr>", { desc = "Previous tab" })

--------------------------------------------------------------------------------
-- Editing & Selection
--------------------------------------------------------------------------------

-- Arrow key selection (standard editor behavior)
set("n", "<S-up>", "v<Up>", { desc = "Select up" })
set("n", "<S-Down>", "v<Down>", { desc = "Select down" })
set("n", "<S-Left>", "v<Left>", { desc = "Select left" })
set("n", "<S-Right>", "v<Right>", { desc = "Select right" })
set("v", "<S-Up>", "<Up>", { desc = "Extend selection up" })
set("v", "<S-Down>", "<Down>", { desc = "Extend selection down" })
set("v", "<S-Left>", "<Left>", { desc = "Extend selection left" })
set("v", "<S-Right>", "<Right>", { desc = "Extend selection right" })
set("i", "<S-Up>", "<Esc>v<Up>", { desc = "Select up" })
set("i", "<S-Down>", "<Esc>`^v<Down>", { desc = "Select down" })
set("i", "<S-Left>", "<Esc>v", { desc = "Select left" })
set("i", "<S-Right>", "<Esc>`^v", { desc = "Select right" })

-- Vim-style visual selection shortcuts
set("n", "K", "v<Up>", { desc = "Select up" })
set("n", "J", "v<Down>", { desc = "Select down" })
set("n", "H", "v<Left>", { desc = "Select left" })
set("n", "L", "v<Right>", { desc = "Select right" })
set("v", "K", "<Up>", { desc = "Extend selection up" })
set("v", "J", "<Down>", { desc = "Extend selection down" })
set("v", "H", "<Left>", { desc = "Extend selection left" })
set("v", "L", "<Right>", { desc = "Extend selection right" })

-- Clipboard operations
set({ "n", "i", "c", "o", "s" }, "<C-a>", "ggVG", { desc = "Select all" })
set("v", "<C-c>", '"+y', { desc = "Copy to system clipboard" })
set("v", "<C-x>", '"+x', { desc = "Cut to system clipboard" })
set("i", "<C-v>", '<Esc>"+pa', { desc = "Paste from system clipboard" })

-- Deletion and Pasting
set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })
set("v", "<Backspace>", '"_d', { desc = "Delete selection" })
set("v", "p", '"0p', { desc = "Paste without yanking over selection" })
set("v", "I", "<C-v>I", { desc = "Visual block insert" })

-- Move lines
set("i", "<C-Down>", "<Esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
set("i", "<C-Up>", "<Esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })

-- Indentation
set("v", "<Tab>", ">gv", { desc = "Indent block" })
set("v", "<S-Tab>", "<gv", { desc = "Unindent block" })
set("i", "<S-Tab>", "<C-O>V<", { desc = "Unindent line" })
set("n", "<S-Tab>", "<<", { desc = "Unindent line" })
set("n", "<Tab>", ">>", { desc = "Indent line" })

-- Undo break points
set("i", "<C-u>", "<C-g>u<C-u>", { desc = "Undo breakpoint for line deletion" })
set("i", "<C-w>", "<C-g>u<C-w>", { desc = "Undo breakpoint for word deletion" })

-- Surround (using mini.surround logic via sa)
set("v", "(", "sa)", { remap = true, desc = "Surround with ()" })
set("v", "[", "sa]", { remap = true, desc = "Surround with []" })
set("v", "{", "sa}", { remap = true, desc = "Surround with {}" })
set("v", '"', 'sa"', { remap = true, desc = 'Surround with ""' })
set("v", "'", "sa'", { remap = true, desc = "Surround with ''" })
set("v", "<", "sa>", { remap = true, desc = "Surround with <>" })

-- Utilities
set("v", "<leader>-", "0<C-v>I- <Esc>", { desc = "Turn into bullet list" })
set("n", "<leader>n", function()
	return "a" .. os.date("%d.%m.%Y")
end, { expr = true, desc = "Insert current date" })
set("n", "<leader>X", "VxGp", { desc = "Move line to bottom of file" })

--------------------------------------------------------------------------------
-- UI & Windows
--------------------------------------------------------------------------------

-- Zoom/Balance panes
set("n", "<leader>z", "<cmd>wincmd _<cr>:wincmd |<cr>", { desc = "Zoom current pane" })
set("n", "<leader>Z", "<cmd>wincmd =<cr>", { desc = "Balance all panes" })

-- Diff toggle
set("n", "<C-M-c>", function()
	if vim.wo.diff then
		vim.cmd("diffoff!")
	else
		vim.cmd("windo :diffthis | :set nofoldenable")
	end
end, { desc = "Toggle diff mode in split" })

-- Split view
set(
	"n",
	"<leader>5",
	"<cmd>vsp<cr><C-w><Left><cmd>bprev<cr><C-w><Right>",
	{ desc = "Split vertically with previous buffer" }
)

-- Pane movement (custom)
set({ "n", "v" }, "<leader>m", 'V"0x<C-w><C-w>"0p<C-w><C-p>', { desc = "Move line to next window" })

--------------------------------------------------------------------------------
-- Git & Terminal
--------------------------------------------------------------------------------

-- Git
set("n", "<leader>g", function()
	Snacks.lazygit.open()
end, { desc = "Open lazygit" })

-- Terminal
set("n", "<leader>t", function()
	Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })

-- Terminal mode mappings
set("t", "jk", "<C-\\><C-n>", { desc = "Escape terminal mode" })
set("t", "kj", "<C-\\><C-n>", { desc = "Escape terminal mode" })
set("t", "<C-w>", "<C-\\><C-n><C-w>", { desc = "Terminal window command" })
set("t", "<C-h>", "<C-\\><C-n><C-w><left>", { desc = "Terminal move left" })
set("t", "<C-j>", "<C-\\><C-n><C-w><down>", { desc = "Terminal move down" })
set("t", "<C-k>", "<C-\\><C-n><C-w><up>", { desc = "Terminal move up" })
set("t", "<C-l>", "<C-\\><C-n><C-w><right>", { desc = "Terminal move right" })

--------------------------------------------------------------------------------
-- LSP & Plugins
--------------------------------------------------------------------------------

-- LSP
set("n", "<leader>ff", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })
set("n", "<leader>lö", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Previous diagnostic" })
set("n", "<leader>lä", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP hover" })
set("n", "<leader>lc", vim.lsp.buf.rename, { desc = "LSP rename" })
set("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document symbols" })
set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Go to definition" })
set("n", "<leader>lr", "<cmd>Telescope lsp_references<cr>", { desc = "LSP references" })
set("n", "<leader>li", "<cmd>Mason<cr>", { desc = "Open Mason" })
set("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Open Lazy" })
set("n", "<leader>u", "<cmd>Lazy sync<cr>", { desc = "Update packages" })

--------------------------------------------------------------------------------
-- Config Management
--------------------------------------------------------------------------------

-- Open or reload vim config
set("n", "<leader>,", function()
	vim.cmd("if @% == '' | lcd ~/.config/nvim | end")
	vim.cmd("args ~/.config/nvim/init.lua ~/.config/nvim/lua/*.lua")
end, { desc = "Open Neovim configuration files" })

set("n", "<leader>.", function()
	local files = { "autocmds", "mappings", "settings", "lazy-init" }
	for _, name in ipairs(files) do
		package.loaded[name] = nil
	end
	dofile(vim.env.MYVIMRC)
	vim.notify("Config reloaded.")
end, { desc = "Reload Neovim configuration" })

-- Colorscheme toggle
local themes = { "tokyonight-night", "tokyonight-day", "onedark" }
local theme_n = 1
set("n", "<leader>c", function()
	theme_n = theme_n % #themes + 1
	vim.cmd.colorscheme(themes[theme_n])
	vim.notify("Colorscheme: " .. themes[theme_n])
end, { desc = "Cycle colorschemes" })
