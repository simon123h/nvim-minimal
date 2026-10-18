-- compile a latex file
-- vim.keymap.set("", "<F5>", "<cmd>!pdflatex '%:p'<cr>", { buffer = true })
local texterm = nil
vim.keymap.set("", "<F5>", function()
	local fdir = vim.fn.expand("%:p:h")
	local fname = vim.fn.expand("%:t")
	if texterm == nil then
		local Terminal = require("toggleterm.terminal").Terminal
		texterm = Terminal:new({ hidden = true, close_on_exit = true })
	end
	if not texterm:is_open() then
		texterm:open()
	else
		texterm:send(vim.api.nvim_replace_termcodes("<C-c>clear", true, true, true), true)
	end
	texterm:change_dir(fdir)
	texterm:send('pdflatex -halt-on-error "' .. fname .. '"', true)
end, { buffer = true })
