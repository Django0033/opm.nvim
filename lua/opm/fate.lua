local M = {}

local constants = require("opm.constants")
local dice = require("opm.dice")

M.OddsError = "Invalid odds. Use: impossible, nearly_impossible, very_unlikely, unlikely, fifty_fifty, likely, very_likely, nearly_certain, certain"

function M.roll_fate(question, odds_key)
	if not odds_key or odds_key == "" then
		odds_key = "fifty_fifty"
	end

	odds_key = string.lower(odds_key)

	local chart = constants.FATE_CHART[odds_key]
	if not chart then
		return nil, M.OddsError
	end

	local roll = dice.roll_d100()
	local result = M.interpret_roll(roll, chart)

	return {
		question = question,
		odds = odds_key,
		odds_display = constants.ODDS_SHORT[odds_key] or odds_key,
		roll = roll,
		result = result.type,
		description = result.description,
		is_exceptional = result.exceptional,
		is_double = dice.is_double(roll),
	}
end

function M.interpret_roll(roll, chart)
	if roll >= chart.exyes[1] and roll <= chart.exyes[2] then
		return { type = "exceptional_yes", description = "EXCEPTIONAL YES", exceptional = true }
	end

	if roll >= chart.exno[1] and roll <= chart.exno[2] then
		return { type = "exceptional_no", description = "EXCEPTIONAL NO", exceptional = true }
	end

	if roll >= chart.yes[1] and roll <= chart.yes[2] then
		return { type = "yes", description = "Yes", exceptional = false }
	end

	return { type = "no", description = "No", exceptional = false }
end

return M
