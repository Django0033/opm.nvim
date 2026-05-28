local M = {}

local defaults = {
	keymaps = {
		picker = "<leader>rr",
		fate = "<leader>rf",
		action = "<leader>ra",
		description = "<leader>rd",
		character = "<leader>rc",
		character_behavior  = "<leader>rb",
		creature            = "<leader>rm",
		creature_behavior   = "<leader>rw",
		adventure           = "<leader>rv",
		mystery_check       = "<leader>rk",
		mystery_descriptor  = "<leader>ry",
		expand              = "<leader>rx",
		expand_fate         = "<leader>r?",
		location_area       = "<leader>rl",
		location_descriptor = "<leader>rs",
		location_exits      = "<leader>re",
	},
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
