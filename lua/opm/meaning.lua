local M = {}

local dice = require("opm.dice")
local tables = require("opm.tables")

local function roll_in_range(tbl, total)
	for _, ent in ipairs(tbl.entries) do
		if total >= ent.min and total <= ent.max then
			return ent.result
		end
	end
	return nil
end

local function roll_range(tbl)
	local total = dice.roll_d100()
	local entry = roll_in_range(tbl, total)
	return total, entry
end

function M.roll_meaning(col)
	col = col or "action"
	if col == "action" then
		local total, entry = roll_range(tables.meaning.action)
		return { roll = total, column = col, word = entry or "Unknown" }
	end
	-- col == "description" is the only other caller
	local total, entry = roll_range(tables.meaning.description)
	return { roll = total, column = col, word = entry or "Unknown" }
end

return M
