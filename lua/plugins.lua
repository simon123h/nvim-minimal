-- Plugins via the native package manager (vim.pack, Neovim 0.12+).
-- Everything here is pure Lua: no build steps, no external binaries.
-- Update with `:lua vim.pack.update()`; versions are pinned in nvim-pack-lock.json.
local gh = function(repo)
	return "https://github.com/" .. repo
end

local ok, err = pcall(vim.pack.add, {
	gh("folke/tokyonight.nvim"),
	gh("nvim-mini/mini.nvim"), -- monolithic: one clone for all mini.* modules
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

-- Like setup(), but runs only once, on first use. Keeps rarely-used modules
-- out of startup (fewer files to read). `after` runs once after a successful setup.
local lazy = {}
local function use(mod, opts, after)
	if lazy[mod] == nil then
		lazy[mod] = setup(mod, opts) or false
		if lazy[mod] and after then
			after(lazy[mod])
		end
	end
	return lazy[mod] or nil
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

--------------------------------------------------------------------------------
-- Loaded at startup
--------------------------------------------------------------------------------

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
setup("mini.statusline", {
	use_icons = false,
	content = {
		-- Default layout minus the git/diagnostics/lsp sections (nothing feeds them here); diff comes from mini.diff
		active = function()
			local sl = MiniStatusline
			local mode, mode_hl = sl.section_mode({ trunc_width = 120 })
			local location = sl.is_truncated(75) and "%p%% %2l:%v" or "%3p%% %3l:%v"
			return sl.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { sl.section_diff({ trunc_width = 75 }) } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { sl.section_filename({ trunc_width = 140 }) } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { sl.section_fileinfo({ trunc_width = 120 }) } },
				{ hl = mode_hl, strings = { sl.section_searchcount({ trunc_width = 75 }), location } },
			})
		end,
	},
})
vim.opt.showmode = false -- the status line shows the mode

-- Buffer tabs (plain text, no icons)
setup("mini.tabline", { show_icons = false })

-- Highlight other occurrences of the word under the cursor
setup("mini.cursorword")

-- Git gutter. Runs `git` twice per buffer (find the repo, read the index version);
-- the diff itself is computed in-process.
setup("mini.diff", {
	view = { style = "sign" },
	mappings = { goto_prev = "gö", goto_next = "gä" },
})

--------------------------------------------------------------------------------
-- Loaded on first use
--------------------------------------------------------------------------------

local set = vim.keymap.set

-- File explorer
set("n", "-", function()
	local files = use("mini.files")
	if not files then
		return
	end
	local name = vim.api.nvim_buf_get_name(0)
	if not files.close() then
		-- open at the current file; fall back to cwd for unnamed/missing paths
		files.open(vim.uv.fs_stat(name) and name or nil)
	end
end, { desc = "Edit parent directory" })

-- Starting on a directory (`nvim .`): set mini.files up now so it replaces netrw
if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
	use("mini.files")
end

-- Buffer-local <Esc> closes the explorer (overrides the global multicursor <Esc>)
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		set("n", "<Esc>", function() require("mini.files").close() end, { buffer = args.data.buf_id, desc = "Close explorer" })
	end,
})

-- Pickers (mini.extra needs mini.pick set up first)
local function pick()
	return use("mini.pick")
end
local function extra_picker(name, opts)
	return function()
		if pick() and use("mini.extra") then
			MiniExtra.pickers[name](opts)
		end
	end
end

local native_select = vim.ui.select
vim.ui.select = function(...)
	local p = pick()
	return (p and p.ui_select or native_select)(...)
end

set("n", "<C-p>", function() if pick() then MiniPick.builtin.files() end end, { desc = "Find files" })
set("n", "<leader>b", function() if pick() then MiniPick.builtin.buffers() end end, { desc = "Find open buffer" })
set("n", "<leader>p", extra_picker("commands"), { desc = "Command Palette" })
set("n", "<leader>k", extra_picker("keymaps"), { desc = "Keymaps Palette" })
set("n", "<leader>r", extra_picker("registers"), { desc = "Show registers" })
set("n", "<C-f>", extra_picker("buf_lines", { scope = "current" }), { desc = "Fuzzy find in current file" })

-- Multicursor
local function mc_call(method, ...)
	local args = { ... }
	return function()
		local mc = use("multicursor-nvim", nil, function(mc)
			-- Custom <Esc> that only takes over once multicursor is loaded
			set("n", "<Esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				elseif mc.hasCursors() then
					mc.clearCursors()
				else
					vim.cmd("noh")
				end
			end, { desc = "Clear cursors or search highlight" })
		end)
		if mc then
			mc[method](unpack(args))
		end
	end
end

set({ "n", "v" }, "<M-Up>", mc_call("lineAddCursor", -1), { desc = "Add cursor above" })
set({ "n", "v" }, "<M-Down>", mc_call("lineAddCursor", 1), { desc = "Add cursor below" })
set({ "n", "v" }, "<M-Right>", mc_call("nextCursor"), { desc = "Next cursor" })
set({ "n", "v" }, "<M-Left>", mc_call("prevCursor"), { desc = "Previous cursor" })
set("v", "<C-d>", mc_call("matchAddCursor", 1), { desc = "Add cursor to next match" })
set({ "n", "v" }, "<C-k><C-d>", mc_call("matchSkipCursor", 1), { desc = "Skip next match" })
set("n", "<C-LeftMouse>", mc_call("handleMouse"), { desc = "Add/remove cursor with mouse" })
set({ "n", "v" }, "<C-q>", mc_call("toggleCursor"), { desc = "Toggle cursor" })
