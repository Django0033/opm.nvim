local M = {}

function M.setup()
	math.randomseed(os.time())
end

local function roll_die(sides)
	return math.random(1, sides)
end

function M.roll_dice(sides)
	return roll_die(sides)
end

function M.roll_d100()
	return roll_die(100)
end

function M.roll_d10()
	return roll_die(10)
end

function M.is_double(n)
	return n % 11 == 0 and n < 100
end

--- Roll d10 and look up result in a statistics table.
--- @param stats_table table: table with .entries array of {min, max, result}
--- @return number, string: roll value and matching result text
function M.roll_statistics(stats_table)
	local roll = M.roll_d10()
	for _, entry in ipairs(stats_table.entries) do
		if roll >= entry.min and roll <= entry.max then
			return roll, entry.result
		end
	end
	return roll, "Unknown"
end

return M
