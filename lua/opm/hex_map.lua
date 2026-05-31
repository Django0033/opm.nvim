local M = {}

local dice = require("opm.dice")
local tables = require("opm.tables")

function M.roll_new_hex(chaos)
	chaos = tonumber(chaos) or 1
	if chaos < 1 then chaos = 1 end
	if chaos > 9 then chaos = 9 end

	local modifier = tables.hex_map.chaos_modifier.entries[chaos]
	local d1 = dice.roll_d10()
	local d2 = dice.roll_d10()
	local raw = d1 + d2
	local is_double = d1 == d2
	local total = raw + modifier
	if total < 2 then total = 2 end
	if total > 20 then total = 20 end

	for _, entry in ipairs(tables.hex_map.new_hex.entries) do
		if total >= entry.min and total <= entry.max then
			local mod_sign = modifier >= 0 and "+" or ""
			local text = string.format("tbl: New Hex 2d10[%d,%d]%s%d=%d -> %s",
				d1, d2, mod_sign, modifier, total, entry.result)
			return text, total, entry.result, is_double
		end
	end

	local mod_sign = modifier >= 0 and "+" or ""
	local text = string.format("tbl: New Hex 2d10[%d,%d]%s%d=%d -> %s",
		d1, d2, mod_sign, modifier, total, "Unknown")
	return text, total, "Unknown", is_double
end

function M.roll_terrain()
	local d1 = dice.roll_d10()
	local d2 = dice.roll_d10()
	local total = d1 + d2

	for _, entry in ipairs(tables.hex_map.terrain.entries) do
		if total >= entry.min and total <= entry.max then
			local text = string.format("tbl: Hex Terrain 2d10=%d -> %s", total, entry.result)
			return text, total, entry.result
		end
	end

	local text = string.format("tbl: Hex Terrain 2d10=%d -> %s", total, "Unknown")
	return text, total, "Unknown"
end

function M.roll_poi()
	local d1 = dice.roll_d10()
	local d2 = dice.roll_d10()
	local total = d1 + d2

	for _, entry in ipairs(tables.hex_map.poi.entries) do
		if total >= entry.min and total <= entry.max then
			local dev_roll = dice.roll_dice(6)
			for _, dev in ipairs(entry.developments) do
				if dev_roll >= dev.min and dev_roll <= dev.max then
					local text = string.format("tbl: Hex POI 2d10=%d -> %s — (1d6=%d) %s",
						total, entry.name, dev_roll, dev.text)
					return text, total, entry.name, dev_roll, dev.text
				end
			end
		end
	end

	local text = string.format("tbl: Hex POI 2d10=%d -> %s", total, "Unknown")
	return text, total, "Unknown", 0, ""
end

return M
