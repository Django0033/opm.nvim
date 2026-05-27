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

	local function roll()
		return dice.roll_d100()
	end

	local identity_roll = roll()
	local mind_roll = roll()
	local body_roll = roll()
	local talent_roll = roll()

	local identity_word = tables.character.identity.entries[identity_roll]
	local mind_word = tables.character.mind.entries[mind_roll]
	local body_word = tables.character.body.entries[body_roll]
	local talent_word = tables.character.talent.entries[talent_roll]

	local insert_text = string.format(
		"gen: Character\n    Identity: d100=%d -> %s\n    Mind: d100=%d -> %s\n    Body: d100=%d -> %s\n    Talent: d100=%d -> %s",
		identity_roll, identity_word,
		mind_roll, mind_word,
		body_roll, body_word,
		talent_roll, talent_word
	)

	local lines = vim.split(insert_text, "\n", { trimempty = true })
	ui.show_result("Character", lines, { title = "Opm", insert_text = insert_text })
end, { nargs = 0, desc = "Generate a character with One-Page Character Crafter" })

vim.api.nvim_create_user_command("OpmCharacterBehavior", function()
	local ui = require("opm.ui")
	local behavior = require("opm.behavior")

	local result = behavior.roll_behavior()
	local display_text = string.format("tbl: CharacterBehavior d100=%d -> %s",
		result.roll, result.result)
	ui.show_result("CharacterBehavior", { display_text }, { title = "Opm", insert_text = display_text })
end, { nargs = 0, desc = "Roll for character behavior context" })

vim.api.nvim_create_user_command("OpmCreature", function()
	local ui = require("opm.ui")
	local dice = require("opm.dice")
	local tables = require("opm.tables")

	local function roll(tbl)
		return tbl.entries[dice.roll_d100()]
	end

	local desc1 = roll(tables.creature.descriptor)
	local desc2 = roll(tables.creature.descriptor)
	local behavior = tables.creature.behavior_initial.entries[dice.roll_d10()]

	local lines = {
		"One-Page Creature",
		string.rep("─", 40),
		"",
		"APPEARANCE:",
		"  " .. desc1 .. ", " .. desc2,
		"",
		"INITIAL BEHAVIOR:",
		"  " .. behavior,
	}

	if behavior == "Exhibits an Ability" then
		local ability1 = roll(tables.creature.ability)
		local ability2 = roll(tables.creature.ability)
		table.insert(lines, "")
		table.insert(lines, "ABILITY:")
		table.insert(lines, "  " .. ability1 .. " / " .. ability2)
	end

	table.insert(lines, "")
	table.insert(lines, "Reroll with :OpmCreature")

	ui.show_result("Creature Crafter", lines, { title = "Opm" })
end, { nargs = 0, desc = "Generate a creature with One-Page Creature Crafter" })

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
