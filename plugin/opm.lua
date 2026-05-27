local function get_odds_completion(arglead, cmdline, cursor)
	local odds = {
		"impossible", "nearly_impossible", "very_unlikely", "unlikely",
		"fifty_fifty", "likely", "very_likely", "nearly_certain", "certain",
	}
	if arglead and arglead ~= "" then
		odds = vim.tbl_filter(function(v)
			return v:lower():find(arglead:lower(), 1, true)
		end, odds)
	end
	return odds
end

vim.api.nvim_create_user_command("OpmFate", function(opts)
	local args = vim.split(opts.args, "|")
	local question = args[1] or ""
	local odds_key = args[2] or "fifty_fifty"

	if question == "" then
		vim.ui.input({ prompt = "Question (Yes/No): " }, function(q)
			if not q or q == "" then
				vim.notify("opm: Question required", vim.log.levels.WARN)
				return
			end
			local fate = require("opm.fate")
			local ui = require("opm.ui")

			vim.ui.input({ prompt = "Odds [fifty_fifty]: " }, function(o)
				o = o or "fifty_fifty"
				local result, err = fate.roll_fate(q, o)
				if err then
					vim.notify("opm: " .. err, vim.log.levels.ERROR)
					return
				end

				local lines = fate.format_result(result)
				ui.show_result("Fate Question", lines, { title = "Opm" })

				if result.is_double then
					vim.defer_fn(function()
						vim.notify("opm: Random Event triggered by double!", vim.log.levels.WARN)
					end, 100)
				end
			end)
		end)
	else
		local fate = require("opm.fate")
		local ui = require("opm.ui")
		local result, err = fate.roll_fate(question, odds_key)
		if err then
			vim.notify("opm: " .. err, vim.log.levels.ERROR)
			return
		end
		local lines = fate.format_result(result)
		ui.show_result("Fate Question", lines, { title = "Opm" })

		if result.is_double then
			vim.defer_fn(function()
				vim.notify("opm: Random Event triggered!", vim.log.levels.WARN)
			end, 100)
		end
	end
end, { nargs = "*", complete = get_odds_completion, desc = "Ask a Yes/No question to the oracle" })

vim.api.nvim_create_user_command("OpmAction", function()
	local meaning = require("opm.meaning")
	local ui = require("opm.ui")
	local r1 = meaning.roll_meaning("action")
	local r2 = meaning.roll_meaning("action")
	local display_text = string.format("tbl: Action 2d100=%d,%d -> %s/%s",
		r1.roll, r2.roll, r1.word, r2.word)
	ui.show_result("Action", { display_text }, { title = "Opm", insert_text = display_text })
end, { nargs = 0, desc = "Get 2 random action words from Meaning table" })

vim.api.nvim_create_user_command("OpmDescription", function()
	local meaning = require("opm.meaning")
	local ui = require("opm.ui")
	local r1 = meaning.roll_meaning("description")
	local r2 = meaning.roll_meaning("description")
	local display_text = string.format("tbl: Description 2d100=%d,%d -> %s/%s",
		r1.roll, r2.roll, r1.word, r2.word)
	ui.show_result("Description", { display_text }, { title = "Opm", insert_text = display_text })
end, { nargs = 0, desc = "Get 2 random description words from Meaning table" })

vim.api.nvim_create_user_command("OpmCharacter", function()
	local ui = require("opm.ui")
	local dice = require("opm.dice")
	local tables = require("opm.tables")

	local function roll_d100()
		return dice.roll_d100()
	end

	local identity_roll = roll_d100()
	local mind_roll = roll_d100()
	local body_roll = roll_d100()
	local talent_roll = roll_d100()

	local identity_word = tables.character.identity.entries[identity_roll]
	local mind_word = tables.character.mind.entries[mind_roll]
	local body_word = tables.character.body.entries[body_roll]
	local talent_word = tables.character.talent.entries[talent_roll]

	local stats_roll = dice.roll_d10()
	local stats_tbl = tables.statistics.statistics
	local stats_result = "Unknown"
	for _, entry in ipairs(stats_tbl.entries) do
		if stats_roll >= entry.min and stats_roll <= entry.max then
			stats_result = entry.result
			break
		end
	end

	local insert_text = string.format(
		"gen: Character\n    Identity: d100=%d -> %s\n    Mind: d100=%d -> %s\n    Body: d100=%d -> %s\n    Talent: d100=%d -> %s\n    Statistics: d10=%d -> %s",
		identity_roll, identity_word,
		mind_roll, mind_word,
		body_roll, body_word,
		talent_roll, talent_word,
		stats_roll, stats_result
	)

	local lines = vim.split(insert_text, "\n", { trimempty = true })
	ui.show_result("Character", lines, { title = "Opm", insert_text = insert_text })
end, { nargs = 0, desc = "Generate a character with One-Page Character Crafter" })

vim.api.nvim_create_user_command("OpmCharacterBehavior", function()
	local ui = require("opm.ui")
	local behavior = require("opm.behavior")

	local result = behavior.roll_behavior()
	local display_text = string.format("tbl: Character Behavior d100=%d -> %s",
		result.roll, result.result)
	ui.show_result("Character Behavior", { display_text }, { title = "Opm", insert_text = display_text })
end, { nargs = 0, desc = "Roll for character behavior context" })

vim.api.nvim_create_user_command("OpmCreature", function()
	local ui = require("opm.ui")
	local dice = require("opm.dice")
	local tables = require("opm.tables")

	local didx1 = dice.roll_d100()
	local didx2 = dice.roll_d100()
	local desc1 = tables.creature.descriptor.entries[didx1]
	local desc2 = tables.creature.descriptor.entries[didx2]

	local bidx = dice.roll_d10()
	local behavior = tables.creature.behavior_initial.entries[bidx]

	local aidx1 = dice.roll_d100()
	local aidx2 = dice.roll_d100()
	local ability1 = tables.creature.ability.entries[aidx1]
	local ability2 = tables.creature.ability.entries[aidx2]

	local stats_roll = dice.roll_d10()
	local stats_tbl = tables.statistics.statistics
	local stats_result = "Unknown"
	for _, entry in ipairs(stats_tbl.entries) do
		if stats_roll >= entry.min and stats_roll <= entry.max then
			stats_result = entry.result
			break
		end
	end

	local insert_text = string.format(
		"gen: Creature\n    Appearance: 2d100=%d,%d -> %s/%s\n    Behavior: d10=%d -> %s\n    Ability: 2d100=%d,%d -> %s/%s\n    Statistics: d10=%d -> %s",
		didx1, didx2, desc1, desc2,
		bidx, behavior,
		aidx1, aidx2, ability1, ability2,
		stats_roll, stats_result
	)

	local lines = vim.split(insert_text, "\n", { trimempty = true })
	ui.show_result("Creature", lines, { title = "Opm", insert_text = insert_text })
end, { nargs = 0, desc = "Generate a creature with One-Page Creature Crafter" })

vim.api.nvim_create_user_command("OpmCreatureBehavior", function()
	local ui = require("opm.ui")
	local creature_behavior = require("opm.creature_behavior")

	local result = creature_behavior.roll_new_behavior()
	local display_text = string.format("tbl: Creature Behavior d10=%d -> %s",
		result.roll, result.result)
	ui.show_result("Creature Behavior", { display_text }, { title = "Opm", insert_text = display_text })
end, { nargs = 0, desc = "Roll for creature new behavior" })

vim.api.nvim_create_user_command("OpmAdventure", function()
	local ui = require("opm.ui")
	local dice = require("opm.dice")
	local tables = require("opm.tables")

	local theme_tbl = tables.adventure.themes
	local theme = theme_tbl.entries[dice.roll_d10()]

	local theme_map = {
		Action = tables.adventure.plot_action,
		Tension = tables.adventure.plot_tension,
		Mystery = tables.adventure.plot_mystery,
		Social = tables.adventure.plot_social,
		Personal = tables.adventure.plot_personal,
	}

	local theme_plot = theme_map[theme]
	if not theme_plot then
		theme_plot = tables.adventure.plot_action
	end

	local function roll(tbl)
		return tbl.entries[dice.roll_d100()]
	end

	local pp = {}
	for i = 1, 5 do
		if i == 1 then
			table.insert(pp, { theme = theme, word = roll(theme_plot) })
		else
			local t = theme_tbl.entries[dice.roll_d10()]
			local pt = theme_map[t] or tables.adventure.plot_action
			table.insert(pp, { theme = t, word = roll(pt) })
		end
	end

	local lines = {
		"One-Page Adventure Crafter",
		string.rep("─", 40),
		"",
		"MAIN THEME: " .. theme,
		"",
		"TURNING POINT:",
	}

	for i, p in ipairs(pp) do
		table.insert(lines, string.format("  [%d] %-10s %s", i, "(" .. p.theme .. ")", p.word))
	end

	table.insert(lines, "")
	table.insert(lines, "Interpret the Plot Points in context.")

	ui.show_result("Adventure Crafter", lines, { title = "Opm" })
end, { nargs = 0, desc = "Generate an adventure with One-Page Adventure Crafter" })
