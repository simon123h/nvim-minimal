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

-- Save and Quit
set("n", "<C-d>", "viw", { desc = "Select word" })
set("n", "<C-s>", "<cmd>update<cr>", { desc = "Save file" })
set({ "v", "i" }, "<C-s>", "<Esc><cmd>update<cr>", { desc = "Save file" })
set("n", "<leader>s", "<cmd>update<cr>", { desc = "Save file" })
set("n", "<leader>q", "<cmd>q<cr>", { desc = "Close current window" })

-- Line numbers toggle
set("n", "<F4>", function()
	vim.opt.number = not vim.opt.number:get()
	if vim.opt.number:get() then
		vim.opt.relativenumber = not vim.opt.relativenumber:get()
	end
end, { desc = "Toggle line numbers (Normal/Relative/None)" })

-- Close buffer without closing the window
set("n", "<leader>w", function()
	local buf = vim.api.nvim_get_current_buf()
	if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
		vim.cmd("bprevious")
	else
		vim.cmd("enew")
	end
	pcall(vim.cmd.bdelete, buf)
end, { desc = "Close current buffer without closing window" })

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

-- Terminal
set("n", "<leader>t", "<cmd>botright split | terminal<cr>", { desc = "Open terminal" })

-- Window navigation
set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Terminal mode mappings
set("t", "jk", "<C-\\><C-n>", { desc = "Escape terminal mode" })
set("t", "kj", "<C-\\><C-n>", { desc = "Escape terminal mode" })
set("t", "<C-w>", "<C-\\><C-n><C-w>", { desc = "Terminal window command" })
set("t", "<C-h>", "<C-\\><C-n><C-w><left>", { desc = "Terminal move left" })
set("t", "<C-j>", "<C-\\><C-n><C-w><down>", { desc = "Terminal move down" })
set("t", "<C-k>", "<C-\\><C-n><C-w><up>", { desc = "Terminal move up" })
set("t", "<C-l>", "<C-\\><C-n><C-w><right>", { desc = "Terminal move right" })

--------------------------------------------------------------------------------
-- Config Management
--------------------------------------------------------------------------------

-- Open or reload vim config
set("n", "<leader>,", function()
	local dir = vim.fn.stdpath("config")
	local files = vim.list_extend({ dir .. "/init.lua" }, vim.fn.glob(dir .. "/lua/*.lua", false, true))
	vim.cmd("args " .. table.concat(vim.tbl_map(vim.fn.fnameescape, files), " "))
end, { desc = "Open Neovim configuration files" })

set("n", "<leader>.", function()
	dofile(vim.env.MYVIMRC)
	vim.notify("Config reloaded.")
end, { desc = "Reload Neovim configuration" })

set("n", "<leader>u", function() vim.pack.update() end, { desc = "Update plugins" })

-- Colorscheme toggle
local themes = { "tokyonight-night", "tokyonight-day" }
local theme_n = 1
set("n", "<leader>c", function()
	theme_n = theme_n % #themes + 1
	vim.cmd.colorscheme(themes[theme_n])
	vim.notify("Colorscheme: " .. themes[theme_n])
end, { desc = "Cycle colorschemes" })
