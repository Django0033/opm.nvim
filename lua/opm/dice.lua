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

return M
