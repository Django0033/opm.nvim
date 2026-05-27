local M = {}

local dice = require("opm.dice")
local tables = require("opm.tables")

function M.roll_behavior()
	local roll = dice.roll_d100()
	local tbl = tables.behavior.behavior_context

	for _, entry in ipairs(tbl.entries) do
		if roll >= entry.min and roll <= entry.max then
			return { roll = roll, result = entry.result }
		end
	end

	return { roll = roll, result = "Unknown" }
end

return M