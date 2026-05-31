local constants = require("opm.constants")
local ERROR_PREFIX = constants.ERROR_PREFIX .. " "

local function show_double_event(msg)
	vim.defer_fn(function()
		vim.notify(ERROR_PREFIX .. (msg or "Random Event triggered!"), vim.log.levels.WARN)
	end, 100)
end

local function roll_statistics(dice, tables)
	local roll = dice.roll_d10()
	local tbl = tables.statistics.statistics
	for _, entry in ipairs(tbl.entries) do
		if roll >= entry.min and roll <= entry.max then
			return roll, entry.result
		end
	end
	return roll, "Unknown"
end

local function get_odds_completion(arglead, cmdline, cursor)
	local odds = constants.ODDS_TYPES
	local colon_pos = arglead:find(":")
	if not colon_pos then
		return {}
	end
	local odds_prefix = vim.trim(arglead:sub(colon_pos + 1))
	if odds_prefix ~= "" then
		odds = vim.tbl_filter(function(v)
			return v:lower():find(odds_prefix:lower(), 1, true)
		end, odds)
	end
	return odds
end

vim.api.nvim_create_user_command("OpmFate", function(opts)
	local question = opts.args or ""
	local odds_key = "fifty_fifty"

	local colon_pos = question:find(":")
	if colon_pos then
		odds_key = vim.trim(question:sub(colon_pos + 1))
		question = vim.trim(question:sub(1, colon_pos - 1))
		if odds_key == "" then
			odds_key = "fifty_fifty"
		end
	end

	if question == "" then
		vim.ui.input({ prompt = "Question (Yes/No): " }, function(q)
			if not q or q == "" then
				vim.notify(ERROR_PREFIX .. "Question required", vim.log.levels.WARN)
				return
			end
			local fate = require("opm.fate")
			local ui = require("opm.ui")

			vim.ui.select(constants.ODDS_TYPES, {
				prompt = "Odds:",
				default = "fifty_fifty",
			}, function(choice)
				if not choice then return end
				local result, err = fate.roll_fate(q, choice)
				if err then
					vim.notify(ERROR_PREFIX .. err, vim.log.levels.ERROR)
					return
				end

				local insert_text = string.format("? %s\n-> Fate (%s) d100=%d -> %s",
					result.question, result.odds_display, result.roll, result.description)
				local lines = vim.split(insert_text, "\n", { trimempty = true })
				ui.show_result("Fate Question", lines, { title = "Opm", insert_text = insert_text })

				if result.is_double then
					show_double_event()
				end
			end)
		end)
	else
		local fate = require("opm.fate")
		local ui = require("opm.ui")
		local result, err = fate.roll_fate(question, odds_key)
		if err then
			vim.notify(ERROR_PREFIX .. err, vim.log.levels.ERROR)
			return
		end
		local insert_text = string.format("? %s\n-> Fate (%s) d100=%d -> %s",
			result.question, result.odds_display, result.roll, result.description)
		local lines = vim.split(insert_text, "\n", { trimempty = true })
		ui.show_result("Fate Question", lines, { title = "Opm", insert_text = insert_text })

		if result.is_double then
			show_double_event()
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

	local stats_roll, stats_result = roll_statistics(dice, tables)

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

	local stats_roll, stats_result = roll_statistics(dice, tables)

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
	local theme_map = {
		Action = tables.adventure.plot_action,
		Tension = tables.adventure.plot_tension,
		Mystery = tables.adventure.plot_mystery,
		Social = tables.adventure.plot_social,
		Personal = tables.adventure.plot_personal,
	}

	local theme_options = { "Action", "Tension", "Mystery", "Social", "Personal" }
	vim.ui.select(theme_options, {
		prompt = "Adventure Theme:",
		default = "Action",
	}, function(theme)
		if not theme then return end

		local insert_text = "gen: Adventure\n"
		for i = 1, 5 do
			local t_name, p_roll, p_word
			if i == 1 then
				t_name = theme
			else
				t_name = theme_tbl.entries[dice.roll_d10()]
			end
			local pt = theme_map[t_name] or tables.adventure.plot_action
			p_roll = dice.roll_d100()
			p_word = pt.entries[p_roll]
			insert_text = insert_text .. string.format(
				"    [%d] (%s) d100=%d -> %s\n", i, t_name, p_roll, p_word)
		end

		insert_text = insert_text:gsub("\n$", "")
		local lines = vim.split(insert_text, "\n", { trimempty = true })
		ui.show_result("Adventure", lines, { title = "Opm", insert_text = insert_text })
	end)
end, { nargs = 0, desc = "Generate an adventure with One-Page Adventure Crafter" })

vim.api.nvim_create_user_command("OpmMysteryCheck", function(opts)
	local ui = require("opm.ui")
	local mystery = require("opm.mystery")

	local box_count = tonumber(opts.args) or 0
	local result = mystery.roll_check(box_count)
	local display_text = string.format("tbl: Mystery Check d100+%d=%d -> %s",
		result.boxes, result.total, result.result)
	ui.show_result("Mystery Check", { display_text }, { title = "Opm", insert_text = display_text })
end, { nargs = 1, desc = "Discovery Check: d100 + box count" })

vim.api.nvim_create_user_command("OpmMysteryDescriptor", function()
	local ui = require("opm.ui")
	local mystery = require("opm.mystery")

	local result = mystery.roll_descriptor()
	local display_text = string.format("tbl: Mystery Descriptor 2d100=%d,%d -> %s/%s",
		result.roll1, result.roll2, result.word1, result.word2)
	ui.show_result("Mystery Descriptor", { display_text }, { title = "Opm", insert_text = display_text })
end, { nargs = 0, desc = "Roll 2 Mystery Descriptor words" })

vim.api.nvim_create_user_command("OpmHexTerrain", function()
	local hex_map = require("opm.hex_map")
	local ui = require("opm.ui")

	local text, total, result = hex_map.roll_terrain()
	ui.show_result("Hex Terrain", { text }, { title = "Opm", insert_text = text })
end, { nargs = 0, desc = "Roll 2d10 for hex terrain type" })

vim.api.nvim_create_user_command("OpmNewHex", function(opts)
	local hex_map = require("opm.hex_map")
	local ui = require("opm.ui")

	local function show(chaos)
		local text, total, result, is_double = hex_map.roll_new_hex(chaos)
		ui.show_result("New Hex", { text }, { title = "Opm", insert_text = text })
		if is_double then
			show_double_event("Point of Interest triggered! Roll OpmHexPOI")
		end
	end

	local chaos = tonumber(opts.args)
	if chaos == nil then
		vim.ui.input({ prompt = "Chaos Factor (1-9): ", default = "1" }, function(input)
			if not input then return end
			show(tonumber(input) or 1)
		end)
	else
		show(chaos)
	end
end, { nargs = "?", desc = "Roll 2d10 + chaos modifier for next hex terrain" })

vim.api.nvim_create_user_command("OpmHexPOI", function()
	local hex_map = require("opm.hex_map")
	local ui = require("opm.ui")

	local text = hex_map.roll_poi()
	ui.show_result("Hex POI", { text }, { title = "Opm", insert_text = text })
end, { nargs = 0, desc = "Roll 2d10 + 1d6 for a hex point of interest" })

vim.api.nvim_create_user_command("Opm", function()
	local ok, telescope = pcall(require, "telescope")
	if not ok then
		vim.notify(ERROR_PREFIX .. "telescope.nvim required for command picker", vim.log.levels.WARN)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local commands = {
		{ "Fate Oracle", "OpmFate" },
		{ "Hex Terrain", "OpmHexTerrain" },
		{ "New Hex", "OpmNewHex" },
		{ "Hex POI", "OpmHexPOI" },
		{ "Action", "OpmAction" },
		{ "Description", "OpmDescription" },
		{ "Character", "OpmCharacter" },
		{ "Character Behavior", "OpmCharacterBehavior" },
		{ "Creature", "OpmCreature" },
		{ "Creature Behavior", "OpmCreatureBehavior" },
		{ "Adventure", "OpmAdventure" },
		{ "Mystery Check", "OpmMysteryCheck" },
		{ "Mystery Descriptor", "OpmMysteryDescriptor" },
		{ "Location Area", "OpmLocArea" },
		{ "Location Descriptor", "OpmLocDescriptor" },
		{ "Location Exits", "OpmLocExit" },
	}

	pickers.new({}, {
		prompt_title = "OPM",
		finder = finders.new_table({
			results = commands,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry[1],
					ordinal = entry[1],
				}
			end,
		}),
		sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
		attach_mappings = function(prompt_bufnr)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local cmd = selection.value[2]
				if cmd == "OpmMysteryCheck" then
					vim.ui.input({ prompt = "Box count: " }, function(input)
						if input and tonumber(input) then
							vim.cmd(cmd .. " " .. input)
						end
					end)
				else
					vim.cmd(cmd)
				end
			end)
			return true
		end,
	}):find()
end, { nargs = 0, desc = "Open OPM command picker (requires telescope.nvim)" })

vim.api.nvim_create_user_command("OpmLocArea", function(opts)
	local ui = require("opm.ui")
	local location = require("opm.location")

	local function show(pp)
		local result = location.roll_area(pp)
		local lines = vim.split(result, "\n", { trimempty = true })
		ui.show_result("Area", lines, { title = "Opm", insert_text = result })
	end

	local pp = tonumber(opts.args)
	if pp == nil then
		vim.ui.input({ prompt = "PP: " }, function(input)
			if not input then return end
			show(tonumber(input) or 0)
		end)
	else
		show(pp)
	end
end, { nargs = "?", desc = "Roll Location/Encounter/Object for one area (PP = Progress Points)" })

vim.api.nvim_create_user_command("OpmLocDescriptor", function()
	local ui = require("opm.ui")
	local location = require("opm.location")

	local result = location.roll_descriptor()
	local display_text = string.format("tbl: Location Descriptor 2d100=%d,%d -> %s/%s",
		result.roll1, result.roll2, result.word1, result.word2)
	ui.show_result("Location Descriptor", { display_text }, { title = "Opm", insert_text = display_text })
end, { nargs = 0, desc = "Roll 2 Location Descriptor words" })

vim.api.nvim_create_user_command("OpmLocExit", function(opts)
	local ui = require("opm.ui")
	local location = require("opm.location")

	local function show(pp)
		local result = location.roll_exits(pp)
		local lines = vim.split(result, "\n", { trimempty = true })
		ui.show_result("Location Exits", lines, { title = "Opm", insert_text = result })
	end

	local pp = tonumber(opts.args)
	if pp == nil then
		vim.ui.input({ prompt = "PP: " }, function(input)
			if not input then return end
			show(tonumber(input) or 0)
		end)
	else
		show(pp)
	end
end, { nargs = "?", desc = "Roll connector exits for current area (PP = Progress Points)" })
