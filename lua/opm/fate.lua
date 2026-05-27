local M = {}

local constants = require("opm.constants")
local dice = require("opm.dice")

M.OddsError = "Invalid odds. Use: impossible, nearly_impossible, very_unlikely, unlikely, fifty_fifty, likely, very_likely, nearly_certain, certain"

function M.is_valid_odds(odds)
	return constants.ODDS_TYPES[odds] ~= nil
end

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

function M.format_result(fate_result)
	local lines = {}
	table.insert(lines, "┌─────────────────────────────────┐")
	table.insert(lines, "│ FATE QUESTION                   │")
	table.insert(lines, "└─────────────────────────────────┘")
	table.insert(lines, "")
	table.insert(lines, "Q: " .. fate_result.question)
	table.insert(lines, "")
	table.insert(lines, "Odds: " .. fate_result.odds_display)
	table.insert(lines, "Roll: " .. fate_result.roll)
	table.insert(lines, "")
	table.insert(lines, "► " .. fate_result.description)

	if fate_result.is_exceptional then
		table.insert(lines, "")
		table.insert(lines, "(Exceptional Result)")
	end

	if fate_result.is_double then
		table.insert(lines, "")
		table.insert(lines, "⚡ DOUBLE — Random Event triggered!")
	end

	return lines
end

return M
