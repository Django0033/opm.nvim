local helper = require("helper")

describe("opm", function()
	local mythic

	setup(function()
		mythic = require("opm")
		mythic.setup()
	end)

	describe("dice", function()
		local dice

		setup(function()
			dice = require("opm.dice")
			dice.setup()
		end)

		it("rolls d100 in valid range", function()
			for _ = 1, 100 do
				local r = dice.roll_d100()
				assert.is_true(r >= 1 and r <= 100)
			end
		end)

		it("rolls d10 in valid range", function()
			for _ = 1, 100 do
				local r = dice.roll_d10()
				assert.is_true(r >= 1 and r <= 10)
			end
		end)

		it("detects doubles correctly", function()
			assert.is_true(dice.is_double(11))
			assert.is_true(dice.is_double(22))
			assert.is_true(dice.is_double(33))
			assert.is_true(dice.is_double(44))
			assert.is_true(dice.is_double(55))
			assert.is_true(dice.is_double(66))
			assert.is_true(dice.is_double(77))
			assert.is_true(dice.is_double(88))
			assert.is_true(dice.is_double(99))
			assert.is_false(dice.is_double(10))
			assert.is_false(dice.is_double(23))
			assert.is_false(dice.is_double(100))
		end)
	end)

	describe("fate", function()
		local fate

		setup(function()
			fate = require("opm.fate")
		end)

		it("rolls fate with default odds", function()
			local result = fate.roll_fate("Is the door locked?")
			assert.is_not_nil(result)
			assert.is_true(result.roll >= 1 and result.roll <= 100)
			assert.is_true(result.result == "yes" or result.result == "no"
				or result.result == "exceptional_yes" or result.result == "exceptional_no")
		end)

		it("rolls fate with specific odds", function()
			local result = fate.roll_fate("Is it likely?", "likely")
			assert.is_not_nil(result)
			assert.are.equal("likely", result.odds)
			assert.are.equal("Likely", result.odds_display)
		end)

		it("returns error for invalid odds", function()
			local _, err = fate.roll_fate("Test?", "invalid_odds")
			assert.is_not_nil(err)
		end)

		it("triggers double detection", function()
			local called = false
			-- This test just verifies the structure
			local result = fate.roll_fate("Test?")
			assert.is_boolean(result.is_double)
		end)
	end)

	describe("meaning", function()
		local meaning

		setup(function()
			meaning = require("opm.meaning")
		end)

		it("rolls meaning for action column", function()
			local result = meaning.roll_meaning("action")
			assert.is_not_nil(result)
			assert.are.equal("action", result.column)
			assert.is_true(result.roll >= 1 and result.roll <= 100)
			assert.is_string(result.word)
		end)

		it("rolls meaning for description column", function()
			local result = meaning.roll_meaning("description")
			assert.is_not_nil(result)
			assert.are.equal("description", result.column)
		end)

		it("rolls event", function()
			local event = meaning.roll_event()
			assert.is_not_nil(event)
			assert.is_boolean(event.is_double)
			assert.is_true(event.roll >= 1 and event.roll <= 100)
		end)
	end)

	describe("tables", function()
		local tables

		setup(function()
			tables = require("opm.tables")
		end)

		it("loads meaning tables", function()
			assert.is_not_nil(tables.meaning)
			assert.is_not_nil(tables.meaning.action)
			assert.is_not_nil(tables.meaning.description)
		end)

		it("loads character tables", function()
			assert.is_not_nil(tables.character)
			assert.is_not_nil(tables.character.identity)
			assert.is_not_nil(tables.character.talent)
			assert.is_not_nil(tables.character.body)
			assert.is_not_nil(tables.character.mind)
		end)

		it("loads creature tables", function()
			assert.is_not_nil(tables.creature)
			assert.is_not_nil(tables.creature.descriptor)
			assert.is_not_nil(tables.creature.behavior_initial)
			assert.is_not_nil(tables.creature.behavior_new)
			assert.is_not_nil(tables.creature.ability)
		end)

		it("loads adventure tables", function()
			assert.is_not_nil(tables.adventure)
			assert.is_not_nil(tables.adventure.themes)
			assert.is_not_nil(tables.adventure.plot_action)
			assert.is_not_nil(tables.adventure.plot_tension)
		end)
	end)
end)
