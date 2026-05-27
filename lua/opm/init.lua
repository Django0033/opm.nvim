local M = {}

M.config = require("opm.config")
M.dice = require("opm.dice")
M.fate = require("opm.fate")
M.meaning = require("opm.meaning")
M.ui = require("opm.ui")
function M.setup(opts)
	opts = opts or {}
	M.config.setup(opts)
	M.dice.setup()
end

return M
