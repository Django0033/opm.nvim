local M = {}

local defaults = {
	float = { border = "rounded", height = 0.4, width = 0.6 },
}

M.options = vim.deepcopy(defaults)

function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

function M.get()
	return M.options
end

return M
