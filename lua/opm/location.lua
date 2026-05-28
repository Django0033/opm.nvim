local M = {}

local dice = require("opm.dice")
local tables = require("opm.tables")

local descriptors_roll_type = { ["Random"] = true, ["Random, Hazard"] = true, ["Random, Discovery"] = true }

local function roll_descriptors()
	local d1 = dice.roll_d100()
	local d2 = dice.roll_d100()
	local w1 = tables.location.descriptor.entries[d1] or "?"
	local w2 = tables.location.descriptor.entries[d2] or "?"
	return string.format(" (2d100=%d,%d -> %s/%s)", d1, d2, w1, w2)
end

local function lookup_result(total)
	for _, entry in ipairs(tables.location.element.entries) do
		local gte_min = entry.min == nil or total >= entry.min
		local lte_max = entry.max == nil or total <= entry.max
		if gte_min and lte_max then
			return entry.result
		end
	end
	return "Unknown"
end

function M.roll_area(pp)
	pp = tonumber(pp) or 0

	local categories = { "Location", "Encounter", "Object" }
	local lines = { string.format("gen: Area (PP=%d)", pp) }

	for _, cat in ipairs(categories) do
		local d10_1 = dice.roll_d10()
		local d10_2 = dice.roll_d10()
		local total = d10_1 + d10_2 + pp
		local result = lookup_result(total)
		local detail = ""
		if descriptors_roll_type[result] then
			detail = roll_descriptors()
		end
		table.insert(lines, string.format("    %s: 2d10[%d,%d]%+d=%d -> %s%s",
			cat, d10_1, d10_2, pp, total, result, detail))
	end

	return table.concat(lines, "\n")
end

function M.roll_descriptor()
	local r1 = dice.roll_d100()
	local r2 = dice.roll_d100()
	local w1 = tables.location.descriptor.entries[r1] or "?"
	local w2 = tables.location.descriptor.entries[r2] or "?"
	return { roll1 = r1, roll2 = r2, word1 = w1, word2 = w2 }
end

function M.roll_exits(pp)
	pp = tonumber(pp) or 0

	if pp <= 0 then
		return "tbl: Location Exits (PP=0) -> 3 exits"
	elseif pp <= 3 then
		local roll = dice.roll_dice(3)
		return string.format("tbl: Location Exits (PP=%d) d3=%d -> %d exit%s",
			pp, roll, roll, roll == 1 and "" or "s")
	elseif pp <= 6 then
		local roll = dice.roll_dice(2)
		return string.format("tbl: Location Exits (PP=%d) d2=%d -> %d exit%s",
			pp, roll, roll, roll == 1 and "" or "s")
	else
		return string.format("tbl: Location Exits (PP=%d) -> 1 exit (0 if Complete)", pp)
	end
end

return M
