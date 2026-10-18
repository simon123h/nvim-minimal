return {
	-- git integration
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile", "BufWritePre" },
		opts = {
			trouble = false,
			current_line_blame_opts = { virt_text_pos = "eol" },
			current_line_blame_formatter = " <author_time:%R>, <author_time:%d.%m.%y>",
		},
		keys = {
			{ "gö", "<cmd>Gitsigns prev_hunk<cr>", desc = "Go to previous git change" },
			{ "gä", "<cmd>Gitsigns next_hunk<cr>", desc = "Go to next git change" },
			{ "gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle git blame" },
		},
	},
	-- git diff view
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = { { "<leader>d", "<cmd>DiffviewOpen<cr>", desc = "Open git diff view" } },
	},
	-- bullet points
	{
		"dkarter/bullets.vim",
		config = function()
			vim.g.bullets_checkbox_markers = " .oOx"
		end,
	},
}
