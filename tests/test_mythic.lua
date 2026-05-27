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
				_assert.is_true(r >= 1 and r <= 100)
			end
		end)

		it("rolls d10 in valid range", function()
			for _ = 1, 100 do
				local r = dice.roll_d10()
				_assert.is_true(r >= 1 and r <= 10)
			end
		end)

		it("detects doubles correctly", function()
			_assert.is_true(dice.is_double(11))
			_assert.is_true(dice.is_double(22))
			_assert.is_true(dice.is_double(33))
			_assert.is_true(dice.is_double(44))
			_assert.is_true(dice.is_double(55))
			_assert.is_true(dice.is_double(66))
			_assert.is_true(dice.is_double(77))
			_assert.is_true(dice.is_double(88))
			_assert.is_true(dice.is_double(99))
			_assert.is_false(dice.is_double(10))
			_assert.is_false(dice.is_double(23))
			_assert.is_false(dice.is_double(100))
		end)
	end)

	describe("fate", function()
		local fate

		setup(function()
			fate = require("opm.fate")
		end)

		it("rolls fate with default odds", function()
			local result = fate.roll_fate("Is the door locked?")
			_assert.is_not_nil(result)
			_assert.is_true(result.roll >= 1 and result.roll <= 100)
			_assert.is_true(result.result == "yes" or result.result == "no"
				or result.result == "exceptional_yes" or result.result == "exceptional_no")
		end)

		it("rolls fate with specific odds", function()
			local result = fate.roll_fate("Is it likely?", "likely")
			_assert.is_not_nil(result)
			_assert.are.equal("likely", result.odds)
			_assert.are.equal("Likely", result.odds_display)
		end)

		it("returns error for invalid odds", function()
			local _, err = fate.roll_fate("Test?", "invalid_odds")
			_assert.is_not_nil(err)
		end)

		it("triggers double detection", function()
			local called = false
			-- This test just verifies the structure
			local result = fate.roll_fate("Test?")
			_assert.is_boolean(result.is_double)
		end)
	end)

	describe("meaning", function()
		local meaning

		setup(function()
			meaning = require("opm.meaning")
		end)

		it("rolls meaning for action column", function()
			local result = meaning.roll_meaning("action")
			_assert.is_not_nil(result)
			_assert.are.equal("action", result.column)
			_assert.is_true(result.roll >= 1 and result.roll <= 100)
			_assert.is_string(result.word)
		end)

		it("rolls meaning for description column", function()
			local result = meaning.roll_meaning("description")
			_assert.is_not_nil(result)
			_assert.are.equal("description", result.column)
end)
	end)

	describe("tables", function()
		local tables

		setup(function()
			tables = require("opm.tables")
		end)

		it("loads meaning tables", function()
			_assert.is_not_nil(tables.meaning)
			_assert.is_not_nil(tables.meaning.action)
			_assert.is_not_nil(tables.meaning.description)
		end)

		it("loads character tables", function()
			_assert.is_not_nil(tables.character)
			_assert.is_not_nil(tables.character.identity)
			_assert.is_not_nil(tables.character.talent)
			_assert.is_not_nil(tables.character.body)
			_assert.is_not_nil(tables.character.mind)
		end)

		it("loads creature tables", function()
			_assert.is_not_nil(tables.creature)
			_assert.is_not_nil(tables.creature.descriptor)
			_assert.is_not_nil(tables.creature.behavior_initial)
			_assert.is_not_nil(tables.creature.behavior_new)
			_assert.is_not_nil(tables.creature.ability)
		end)

		it("loads adventure tables", function()
			_assert.is_not_nil(tables.adventure)
			_assert.is_not_nil(tables.adventure.themes)
			_assert.is_not_nil(tables.adventure.plot_action)
			_assert.is_not_nil(tables.adventure.plot_tension)
		end)
	end)
end)
