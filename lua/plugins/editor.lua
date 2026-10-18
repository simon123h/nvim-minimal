return {
	-- fuzzy finding
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-lua/plenary.nvim",
		},
		opts = {
			defaults = { file_ignore_patterns = { "out" } },
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
		end,
		cmd = { "Telescope" },
		keys = {
			{ "<C-t>", "<cmd>Telescope<cr>", desc = "Open Telescope" },
			{ "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find in current file" },
			{ "ff", "<cmd>Telescope live_grep<cr>", desc = "Find in all files" },
			{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Find open buffer" },
			{ "<leader>r", "<cmd>Telescope registers<cr>", desc = "Show registers" },
		},
	},
	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		dependencies = { "HiPhish/rainbow-delimiters.nvim" },
		config = function()
			local ts = require("nvim-treesitter")
			ts.install({
				"bash",
				"c",
				"cpp",
				"diff",
				"fish",
				"gitcommit",
				"vimdoc",
				"html",
				"javascript",
				"json",
				"latex",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"vim",
			})

			-- Enable highlighting; install missing parsers on demand
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang then
						return
					end
					if pcall(vim.treesitter.start, args.buf, lang) then
						return
					end
					if vim.tbl_contains(ts.get_available(), lang) then
						ts.install({ lang }):await(function()
							if vim.api.nvim_buf_is_valid(args.buf) then
								pcall(vim.treesitter.start, args.buf, lang)
							end
						end)
					end
				end,
			})
		end,
	},
	-- oil.nvim
	{
		"stevearc/oil.nvim",
		opts = {
			skip_confirm_for_simple_edits = true,
			keymaps = {
				["<BS>"] = "actions.parent",
				["<Esc>"] = "actions.close",
				["q"] = "actions.close",
				["<C-s>"] = false,
			},
		},
		keys = {
			{
				"-",
				function()
					require("oil").open_float()
				end,
				desc = "Edit parent directory",
			},
		},
		lazy = false,
	},
	-- nvim-tree
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeFocus", "NvimTreeOpen", "NvimTreeToggle" },
		opts = { update_focused_file = { enable = true } },
		keys = { { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" } },
	},
	-- Other tools
	{ "folke/todo-comments.nvim", event = { "BufReadPost", "BufNewFile" }, config = true },
	{ "kevinhwang91/nvim-hlslens", config = true, event = "VeryLazy" },
	{
		"chentoast/marks.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = { mappings = { next = "mä", prev = "mö", toggle = "mm" } },
	},
	{
		"jake-stewart/multicursor.nvim",
		keys = {
			{
				"<M-Up>",
				function()
					require("multicursor-nvim").lineAddCursor(-1)
				end,
				mode = { "n", "v" },
				desc = "Add cursor above",
			},
			{
				"<M-Down>",
				function()
					require("multicursor-nvim").lineAddCursor(1)
				end,
				mode = { "n", "v" },
				desc = "Add cursor below",
			},
			{
				"<M-Right>",
				function()
					require("multicursor-nvim").nextCursor()
				end,
				mode = { "n", "v" },
				desc = "Next cursor",
			},
			{
				"<M-Left>",
				function()
					require("multicursor-nvim").prevCursor()
				end,
				mode = { "n", "v" },
				desc = "Previous cursor",
			},
			{
				"<C-d>",
				function()
					require("multicursor-nvim").matchAddCursor(1)
				end,
				mode = "v",
				desc = "Add cursor to next match",
			},
			{
				"<C-k><C-d>",
				function()
					require("multicursor-nvim").matchSkipCursor(1)
				end,
				mode = { "n", "v" },
				desc = "Skip next match",
			},
			{
				"<c-leftmouse>",
				function()
					require("multicursor-nvim").handleMouse()
				end,
				desc = "Add/remove cursor with mouse",
			},
			{
				"<c-q>",
				function()
					require("multicursor-nvim").toggleCursor()
				end,
				mode = { "n", "v" },
				desc = "Toggle cursor",
			},
		},
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			-- Custom <esc> logic that only activates once multicursor is loaded
			vim.keymap.set("n", "<esc>", function()
				if not mc.cursorsEnabled() then
					mc.enableCursors()
				elseif mc.hasCursors() then
					mc.clearCursors()
				else
					vim.cmd("noh")
				end
			end, { desc = "Clear cursors or search highlight" })
		end,
	},
	{
		"nat-418/boole.nvim",
		config = function()
			require("boole").setup({ mappings = { increment = "gt", decrement = "gT" } })
		end,
	},
	{ "tris203/precognition.nvim", config = { startVisible = false, showBlankVirtLine = true } },
	{ "nvim-mini/mini.surround", version = "*", config = true },
	{
		"nvim-mini/mini.move",
		version = "*",
		opts = {
			mappings = {
				left = "<C-Left>",
				right = "<C-Right>",
				down = "<C-Down>",
				up = "<C-Up>",
				line_down = "<C-Down>",
				line_up = "<C-Up>",
			},
		},
	},
	{ "windwp/nvim-autopairs", event = { "VeryLazy" }, config = true },
	-- Navigate tmux and vim windows with the same commands
	{
		"aserowy/tmux.nvim",
		opts = { copy_sync = { enable = false } },
		keys = {
			{ "<C-h>", "<cmd>lua require('tmux').move_left()<cr>" },
			{ "<C-j>", "<cmd>lua require('tmux').move_down()<cr>" },
			{ "<C-k>", "<cmd>lua require('tmux').move_up()<cr>" },
			{ "<C-l>", "<cmd>lua require('tmux').move_right()<cr>" },
		},
	},
	-- which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			win = { border = "rounded" },
			-- Customize which keys scroll the menu
			keys = {
				scroll_down = "<PageDown>",
				scroll_up = "<PageUp>",
			},
			spec = {
				{ "<leader>f", group = "Formatting" },
				{ "<leader>l", group = "LSP" },
				{ "<leader>g", group = "Git" },
				{ "<leader>x", group = "Diagnostics" },
				{ "<leader>c", group = "Code/Colors" },
				{ "<leader>t", group = "Terminal" },
			},
		},
		keys = {
			{ "<F2>", "<cmd>WhichKey<cr>", desc = "WhichKey" },
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {
			disabled_keys = {
		   		["<Up>"] = false,
		   		["<Down>"] = false,
		   		["<Left>"] = false,
		   		["<Right>"] = false,
			},
			disable_mouse = false,
			restriction_mode = "hint",
		},
	},
}
