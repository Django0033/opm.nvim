local M = {}

local magic = require("opm.meaning")
local dice = require("opm.dice")
local behavior = require("opm.behavior")
local creature_behavior = require("opm.creature_behavior")
local mystery = require("opm.mystery")
local fate = require("opm.fate")
local location = require("opm.location")
local hex_map = require("opm.hex_map")
local tables = require("opm.tables")
local ui = require("opm.ui")

local tbl_formatters = {
	["Action"] = function()
		local r1 = magic.roll_meaning("action")
		local r2 = magic.roll_meaning("action")
		return string.format("tbl: Action 2d100=%d,%d -> %s/%s", r1.roll, r2.roll, r1.word, r2.word)
	end,
	["Description"] = function()
		local r1 = magic.roll_meaning("description")
		local r2 = magic.roll_meaning("description")
		return string.format("tbl: Description 2d100=%d,%d -> %s/%s", r1.roll, r2.roll, r1.word, r2.word)
	end,
	["Character Behavior"] = function()
		local r = behavior.roll_behavior()
		return string.format("tbl: Character Behavior d100=%d -> %s", r.roll, r.result)
	end,
	["Creature Behavior"] = function()
		local r = creature_behavior.roll_new_behavior()
		return string.format("tbl: Creature Behavior d10=%d -> %s", r.roll, r.result)
	end,
	["Mystery Descriptor"] = function()
		local r = mystery.roll_descriptor()
		return string.format("tbl: Mystery Descriptor 2d100=%d,%d -> %s/%s", r.roll1, r.roll2, r.word1, r.word2)
	end,
	["Location Descriptor"] = function()
		local r = location.roll_descriptor()
		return string.format("tbl: Location Descriptor 2d100=%d,%d -> %s/%s", r.roll1, r.roll2, r.word1, r.word2)
	end,
	["Hex Terrain"] = function()
		local text, _, _ = hex_map.roll_terrain()
		return text
	end,
	["Hex POI"] = function()
		local text = hex_map.roll_poi()
		return text
	end,
}

local function roll_d100()
	return dice.roll_d100()
end

local gen_formatters = {
	["Character"] = function()
		local ir, mr, br, tr = roll_d100(), roll_d100(), roll_d100(), roll_d100()
		local iw = tables.character.identity.entries[ir]
		local mw = tables.character.mind.entries[mr]
		local bw = tables.character.body.entries[br]
		local tw = tables.character.talent.entries[tr]
		local sr = dice.roll_d10()
		local st = tables.statistics.statistics
		local sw = "Unknown"
		for _, e in ipairs(st.entries) do
			if sr >= e.min and sr <= e.max then sw = e.result; break end
		end
		return string.format(
			"gen: Character\n    Identity: d100=%d -> %s\n    Mind: d100=%d -> %s\n    Body: d100=%d -> %s\n    Talent: d100=%d -> %s\n    Statistics: d10=%d -> %s",
			ir, iw, mr, mw, br, bw, tr, tw, sr, sw
		)
	end,
	["Creature"] = function()
		local d1, d2 = roll_d100(), roll_d100()
		local dw1 = tables.creature.descriptor.entries[d1]
		local dw2 = tables.creature.descriptor.entries[d2]
		local bi = dice.roll_d10()
		local bw = tables.creature.behavior_initial.entries[bi]
		local a1, a2 = roll_d100(), roll_d100()
		local aw1 = tables.creature.ability.entries[a1]
		local aw2 = tables.creature.ability.entries[a2]
		local sr = dice.roll_d10()
		local st = tables.statistics.statistics
		local sw = "Unknown"
		for _, e in ipairs(st.entries) do
			if sr >= e.min and sr <= e.max then sw = e.result; break end
		end
		return string.format(
			"gen: Creature\n    Appearance: 2d100=%d,%d -> %s/%s\n    Behavior: d10=%d -> %s\n    Ability: 2d100=%d,%d -> %s/%s\n    Statistics: d10=%d -> %s",
			d1, d2, dw1, dw2, bi, bw, a1, a2, aw1, aw2, sr, sw
		)
	end,
	["Adventure"] = function()
		local theme_tbl = tables.adventure.themes
		local theme_map = {
			Action = tables.adventure.plot_action,
			Tension = tables.adventure.plot_tension,
			Mystery = tables.adventure.plot_mystery,
			Social = tables.adventure.plot_social,
			Personal = tables.adventure.plot_personal,
		}
		local theme_options = { "Action", "Tension", "Mystery", "Social", "Personal" }
		local done = false
		vim.ui.select(theme_options, { prompt = "Adventure Theme:", default = "Action" }, function(theme)
			if not theme then return end
			local result = "gen: Adventure\n"
			for i = 1, 5 do
				local t_name
				if i == 1 then
					t_name = theme
				else
					t_name = theme_tbl.entries[dice.roll_d10()]
				end
				local pt = theme_map[t_name] or tables.adventure.plot_action
				local pr = dice.roll_d100()
				local pw = pt.entries[pr]
				result = result .. string.format("    [%d] (%s) d100=%d -> %s\n", i, t_name, pr, pw)
			end
			result = result:gsub("\n$", "")
			local lines = vim.split(result, "\n", { trimempty = true })
			ui.show_result("Adventure", lines, { title = "Opm", insert_text = result })
			done = true
		end)
		return nil, true
	end,
}

local function replace_line(result)
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	vim.api.nvim_buf_set_lines(0, row - 1, row, false, vim.split(result, "\n", { trimempty = true }))
end

function M.expand_current_line()
	local line = vim.api.nvim_get_current_line()
	local trimmed = vim.trim(line)

	if trimmed:match("^tbl: ") then
		local name = trimmed:match("^tbl: (.+)")
		local box_count = nil
		if name then
			box_count = name:match("Mystery Check (%d+)$")
			if box_count then
				local r = mystery.roll_check(tonumber(box_count))
				replace_line(string.format("tbl: Mystery Check d100+%d=%d -> %s", r.boxes, r.total, r.result))
				return
			end
		end
		local chaos = name:match("New Hex (%d+)$")
		if chaos then
			local text, _, _ = hex_map.roll_new_hex(tonumber(chaos))
			replace_line(text)
			return
		end

		local fmt = tbl_formatters[name]
		if fmt then
			replace_line(fmt())
		else
			vim.notify("opm: unknown table: " .. (name or ""), vim.log.levels.WARN)
		end

	elseif trimmed:match("^gen: ") then
		local name = trimmed:match("^gen: (.+)")
		local area_pp = name:match("^Area%s+(%-?%d+)$")
		if area_pp then
			local result = location.roll_area(tonumber(area_pp))
			replace_line(result)
			return
		end
		local fmt = gen_formatters[name]
		if fmt then
			local result, async = fmt()
			if not async then
				replace_line(result)
			end
		else
			vim.notify("opm: unknown generator: " .. (name or ""), vim.log.levels.WARN)
		end
	end
end

function M.expand_fate()
	local line = vim.api.nvim_get_current_line()
	local trimmed = vim.trim(line)
	if not trimmed:match("^%?") then
		vim.notify("opm: line must start with ?", vim.log.levels.WARN)
		return
	end

	local question = trimmed:match("^%? (.+)") or ""
	local odds_key = "fifty_fifty"

	local colon_pos = question:find("%s*:%s*")
	if colon_pos then
		odds_key = vim.trim(question:sub(colon_pos + 1))
		question = vim.trim(question:sub(1, colon_pos - 1))
		if odds_key == "" then odds_key = "fifty_fifty" end
	end

	local result, err = fate.roll_fate(question, odds_key)
	if err then
		vim.notify("opm: " .. err, vim.log.levels.ERROR)
		return
	end

	local text = string.format("? %s\n-> Fate (%s) d100=%d -> %s",
		result.question, result.odds_display, result.roll, result.description)
	replace_line(text)
end

return M
