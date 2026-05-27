local M = {}

local tables_dir = vim.fn.fnamemodify(debug.getinfo(1).source:match("@?(.*)"), ":h")
for _, f in ipairs(vim.split(vim.fn.glob(tables_dir .. "/*.lua"), "\n")) do
	local name = f:match("([^/]+)%.lua$")
	if name and name ~= "init" then
		M[name] = require("opm.tables." .. name)
	end
end

return M
