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
	local action_tbl = tables.meaning.action
	local desc_tbl = tables.meaning.description

	if col == "action" then
		local total, entry = roll_range(action_tbl)
		return { roll = total, column = col, word = entry or "Unknown" }
	elseif col == "description" then
		local total, entry = roll_range(desc_tbl)
		return { roll = total, column = col, word = entry or "Unknown" }
	else
		local action_total, action_entry = roll_range(action_tbl)
		local desc_total, desc_entry = roll_range(desc_tbl)
		return {
			roll = action_total,
			column = "both",
			action = action_entry,
			description = desc_entry,
		}
	end
end

return M
