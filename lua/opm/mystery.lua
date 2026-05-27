local M = {}

local dice = require("opm.dice")
local tables = require("opm.tables")

function M.roll_check(box_count)
	box_count = tonumber(box_count) or 0
	if box_count < 0 then box_count = 0 end

	local roll = dice.roll_d100()
	local total = roll + box_count

	local result = "Unknown"
	for _, entry in ipairs(tables.mystery.check.entries) do
		if total >= entry.min and (entry.max == nil or total <= entry.max) then
			result = entry.result
			break
		end
	end

	return {
		roll = roll,
		boxes = box_count,
		total = total,
		result = result,
	}
end

function M.roll_descriptor()
	local r1 = dice.roll_d100()
	local r2 = dice.roll_d100()
	local w1 = tables.mystery.descriptor.entries[r1] or "Unknown"
	local w2 = tables.mystery.descriptor.entries[r2] or "Unknown"

	return { roll1 = r1, roll2 = r2, word1 = w1, word2 = w2 }
end

return M
