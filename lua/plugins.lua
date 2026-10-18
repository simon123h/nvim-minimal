-- Plugins via the native package manager (vim.pack, Neovim 0.12+).
-- Everything here is pure Lua: no build steps, no external binaries.
-- Update with `:lua vim.pack.update()`; versions are pinned in nvim-pack-lock.json.
local gh = function(repo)
	return "https://github.com/" .. repo
end

local ok, err = pcall(vim.pack.add, {
	gh("folke/tokyonight.nvim"),
	gh("nvim-mini/mini.surround"),
	gh("nvim-mini/mini.move"),
	gh("nvim-mini/mini.pairs"),
	gh("nvim-mini/mini.pick"),
	gh("nvim-mini/mini.statusline"),
	gh("nvim-mini/mini.tabline"),
	gh("nvim-mini/mini.files"),
	gh("nvim-mini/mini.cursorword"),
	gh("lewis6991/gitsigns.nvim"),
	gh("jake-stewart/multicursor.nvim"),
})
if not ok then
	vim.notify("vim.pack failed: " .. tostring(err), vim.log.levels.WARN)
end

-- Set up a plugin only if it is available, so a failed clone never breaks startup
local function setup(mod, opts)
	local loaded, plugin = pcall(require, mod)
	if loaded then
		plugin.setup(opts or {})
	end
	return loaded and plugin or nil
end

-- Colorscheme
setup("tokyonight", {
	style = "night",
	light_style = "day",
	styles = { comments = { italic = false }, keywords = { italic = false } },
	dim_inactive = true,
})
if not pcall(vim.cmd.colorscheme, "tokyonight") then
	vim.cmd.colorscheme("habamax")
end

-- Editing helpers
setup("mini.surround")
setup("mini.pairs")
setup("mini.move", {
	mappings = {
		left = "<C-Left>",
		right = "<C-Right>",
		down = "<C-Down>",
		up = "<C-Up>",
		line_left = "<C-Left>",
		line_right = "<C-Right>",
		line_down = "<C-Down>",
		line_up = "<C-Up>",
	},
})

-- Status line (plain text, no icons)
setup("mini.statusline", { use_icons = false })
vim.opt.showmode = false -- the status line shows the mode

-- Buffer tabs (plain text, no icons)
setup("mini.tabline", { show_icons = false })

-- Highlight other occurrences of the word under the cursor
setup("mini.cursorword")

-- File explorer
local files = setup("mini.files")
if files then
	vim.keymap.set("n", "-", function()
		local name = vim.api.nvim_buf_get_name(0)
		if not files.close() then
			-- open at the current file; fall back to cwd for unnamed/missing paths
			files.open(vim.uv.fs_stat(name) and name or nil)
		end
	end, { desc = "Edit parent directory" })
end

-- File / buffer picker
local pick = setup("mini.pick")
if pick then
	vim.ui.select = pick.ui_select
	vim.keymap.set("n", "<C-p>", pick.builtin.files, { desc = "Find files" })
	vim.keymap.set("n", "<leader>b", pick.builtin.buffers, { desc = "Find open buffer" })
end

-- Git
local gitsigns = setup("gitsigns", {
	current_line_blame_opts = { virt_text_pos = "eol" },
	current_line_blame_formatter = " <author_time:%R>, <author_time:%d.%m.%y>",
})
if gitsigns then
	vim.keymap.set("n", "gö", function() gitsigns.nav_hunk("prev") end, { desc = "Previous git change" })
	vim.keymap.set("n", "gä", function() gitsigns.nav_hunk("next") end, { desc = "Next git change" })
	vim.keymap.set("n", "gB", gitsigns.toggle_current_line_blame, { desc = "Toggle git blame" })
end

-- Multicursor
local mc = setup("multicursor-nvim")
if mc then
	local set = vim.keymap.set
	set({ "n", "v" }, "<M-Up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
	set({ "n", "v" }, "<M-Down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })
	set({ "n", "v" }, "<M-Right>", mc.nextCursor, { desc = "Next cursor" })
	set({ "n", "v" }, "<M-Left>", mc.prevCursor, { desc = "Previous cursor" })
	set("v", "<C-d>", function() mc.matchAddCursor(1) end, { desc = "Add cursor to next match" })
	set({ "n", "v" }, "<C-k><C-d>", function() mc.matchSkipCursor(1) end, { desc = "Skip next match" })
	set("n", "<C-LeftMouse>", mc.handleMouse, { desc = "Add/remove cursor with mouse" })
	set({ "n", "v" }, "<C-q>", mc.toggleCursor, { desc = "Toggle cursor" })
	set("n", "<Esc>", function()
		if not mc.cursorsEnabled() then
			mc.enableCursors()
		elseif mc.hasCursors() then
			mc.clearCursors()
		else
			vim.cmd("noh")
		end
	end, { desc = "Clear cursors or search highlight" })
end
