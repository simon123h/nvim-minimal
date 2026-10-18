return {
	-- colorschemes
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				light_style = "day",
				transparent = false,
				terminal_colors = false,
				styles = {
					comments = { italic = false },
					keywords = { italic = false },
				},
				day_brightness = 0.2,
				hide_inactive_statusline = false,
				dim_inactive = true,
				lualine_bold = true,
			})
		end,
	},
	{
		"navarasu/onedark.nvim",
		lazy = true,
		opts = {
			style = "deep",
			toggle_style_key = "<leader>tt",
			toggle_style_list = { "light", "deep" },
			transparent = true,
			code_style = { comments = "none" },
		},
	},
	-- tab- & bufferline
	{
		"akinsho/bufferline.nvim",
		config = function()
			local bufferline = require("bufferline")
			bufferline.setup({
				options = {
					style_preset = {
						bufferline.style_preset.minimal,
						bufferline.style_preset.no_italic,
					},
					always_show_bufferline = false,
				},
			})
		end,
	},
	-- status line
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = { theme = "auto", icons_enabled = true },
			sections = {
				lualine_x = {
					"encoding",
					"fileformat",
					"filetype",
					{
						require("lazy.status").updates,
						cond = require("lazy.status").has_updates,
						color = { fg = "#ff9e64" },
					},
				},
			},
			extensions = { "lazy", "nvim-tree", "trouble" },
		},
	},
	-- icons
	{
		"nvim-mini/mini.icons",
		opts = {},
		lazy = true,
		specs = {
			{ "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
	-- breadcrumbs/file names
	{ "b0o/incline.nvim", opts = {}, event = { "BufReadPost", "BufNewFile" } },
	-- Scrollbar
	{
		"dstein64/nvim-scrollview",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs_on_startup = { "conflicts", "diagnostics", "marks", "search" },
		},
	},
	-- Snacks: a collection of small plugins
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bufdelete = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true },
			picker = { enabled = true },
			select = { enabled = true },
			statuscolumn = { enabled = true },
			terminal = { enabled = true },
			words = { enabled = true },
		},
	},
	-- Colorful window separator
	{
		"nvim-zh/colorful-winsep.nvim",
		event = "BufEnter",
		opts = { highlight = { fg = "#7AA2F7" } },
	},
}
