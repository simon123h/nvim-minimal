local opt = vim.opt -- to set options

-- Automatically reload buffer contents when the file has changed on disk
opt.autoread = true
-- Confirm before exit without saving
opt.confirm = true
-- Enabe use of the mouse for all modes
opt.mouse = "a"
-- Show line numbers
opt.number = true
-- Always display signcolumn used for errors and git-gutter
opt.signcolumn = "yes"
-- Highlight current line
opt.cursorline = true
-- Command-line completion mode
opt.wildmode = "list:longest,full"
-- Wrap long lines
opt.wrap = true
-- do not break words when wrapping the line
opt.linebreak = true
-- Number of spaces tabs count for
opt.shiftwidth = 4
-- Number of spaces tabs count for
opt.tabstop = 4
-- Round indent to multiple of shiftwidth when shifting lines
opt.shiftround = true
-- enable case-insensitive search
opt.ignorecase = true
-- Do not ignore case with capitals in search
opt.smartcase = true
-- Put new windows below current
opt.splitbelow = true
-- Put new windows right of current
opt.splitright = true
-- Current file title is window title
opt.title = true
-- Allow to move cursor one position past the end of the line
opt.virtualedit = "onemore"
-- jump to next line if line end is reached
opt.whichwrap:append({
	["<"] = true,
	[">"] = true,
	[","] = true,
	h = true,
	l = true,
	["["] = true,
	["]"] = true,
})
-- Show some invisible characters
opt.list = true
vim.opt.listchars = { tab = "> ", leadmultispace = "·   ", trail = "␣", nbsp = "⍽" }
-- vim.opt.listchars = { leadmultispace = "│   ", multispace = "│ ", tab = "│ " }
-- Disable swap files
opt.swapfile = false
-- enable the autocompletion menu
opt.completeopt = "menuone,noselect"
-- decrease update time (default is 4000ms) for faster UI response
opt.updatetime = 250
-- true color support
opt.termguicolors = true
-- disable the startup screen
opt.shortmess:append("I")
-- reserve no space for the command line
opt.laststatus = 3
opt.cmdheight = 1
-- transparency of popup menu
opt.pumblend = 10
-- maximum number of entries in popup menu
opt.pumheight = 10
