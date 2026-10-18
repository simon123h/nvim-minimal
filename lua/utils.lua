local M = {}

-- Hostname distinction
M.hostname = vim.fn.hostname()
M.is_T14 = M.hostname == "T14"

return M
