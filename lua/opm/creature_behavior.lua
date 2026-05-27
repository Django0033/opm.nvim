local M = {}

local dice = require("opm.dice")
local tables = require("opm.tables")

function M.roll_new_behavior()
	local roll = dice.roll_d10()
	local tbl = tables.creature.behavior_new
	local result = tbl.entries[roll] or "Unknown"

	return { roll = roll, result = result }
end

return M
