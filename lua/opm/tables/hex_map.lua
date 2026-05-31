local M = {}

M.terrain = {
	name = "Hex Terrain",
	type = "range",
	dice = "2d10",
	entries = {
		{ min = 2, max = 3, result = "Ocean" },
		{ min = 4, max = 6, result = "River/Coast" },
		{ min = 7, max = 9, result = "Swamp" },
		{ min = 10, max = 12, result = "Grassland" },
		{ min = 13, max = 15, result = "Forest/Jungle" },
		{ min = 16, max = 18, result = "Mountains" },
		{ min = 19, max = 20, result = "Desert/Arctic" },
	},
}

M.new_hex = {
	name = "New Hex",
	type = "range",
	dice = "2d10 + modifier",
	entries = {
		{ min = 2, max = 10, result = "Same as current terrain" },
		{ min = 11, max = 17, result = "Current terrain +1 step" },
		{ min = 18, max = 20, result = "Current terrain +2 step" },
	},
}

M.chaos_modifier = {
	name = "Chaos Modifier",
	type = "simple",
	entries = {
		[1] = -5, [2] = -4, [3] = -2, [4] = -1, [5] = 0,
		[6] = 1,  [7] = 2,  [8] = 4,  [9] = 5,
	},
}

M.poi = {
	name = "Hex POI",
	type = "range",
	dice = "2d10",
	entries = {
		{ min = 2, max = 3, name = "Fortified keep",
			developments = {
				{ min = 1, max = 2, text = "Over/connected to a large tomb" },
				{ min = 3, max = 4, text = "Abandoned, haunted by its defenders" },
				{ min = 5, max = 6, text = "Occupied by a warlord's forces" },
			} },
		{ min = 4, max = 5, name = "Temple",
			developments = {
				{ min = 1, max = 2, text = "Being attacked by an invader" },
				{ min = 3, max = 4, text = "Abandoned — the god has left" },
				{ min = 5, max = 6, text = "Pilgrims gather for a rare ceremony" },
			} },
		{ min = 6, max = 7, name = "Barrow mounds",
			developments = {
				{ min = 1, max = 2, text = "Around/over sleeping dragon" },
				{ min = 3, max = 4, text = "Recently disturbed — something escaped" },
				{ min = 5, max = 6, text = "An ancient king's burial, still guarded" },
			} },
		{ min = 8, max = 9, name = "Village",
			developments = {
				{ min = 1, max = 2, text = "Abandoned and in ruins" },
				{ min = 3, max = 4, text = "Prosperous, but hiding a dark secret" },
				{ min = 5, max = 6, text = "Quarantined — plague or curse" },
			} },
		{ min = 10, max = 11, name = "Town",
			developments = {
				{ min = 1, max = 2, text = "Guarded by its current residents" },
				{ min = 3, max = 4, text = "Preparing for an annual festival" },
				{ min = 5, max = 6, text = "Tense — two factions about to clash" },
			} },
		{ min = 12, max = 13, name = "City/metropolis",
			developments = {
				{ min = 1, max = 2, text = "Under siege by a warband" },
				{ min = 3, max = 4, text = "Ruled by a corrupt council" },
				{ min = 5, max = 6, text = "Built on top of ancient ruins" },
			} },
		{ min = 14, max = 15, name = "Monster's nest",
			developments = {
				{ min = 1, max = 2, text = "Where a secret circle of wizards meets" },
				{ min = 3, max = 4, text = "Breeding ground — the young are everywhere" },
				{ min = 5, max = 6, text = "Recently abandoned — signs of a larger predator" },
			} },
		{ min = 16, max = 17, name = "Cave formation",
			developments = {
				{ min = 1, max = 2, text = "Controlled by a malevolent sorcerer" },
				{ min = 3, max = 4, text = "Natural wonder — draws travelers and scholars" },
				{ min = 5, max = 6, text = "Connects to the Underdark/Deep Roads" },
			} },
		{ min = 18, max = 19, name = "Ancient dolmens",
			developments = {
				{ min = 1, max = 2, text = "Protected by an age-old guardian" },
				{ min = 3, max = 4, text = "A portal to another place or time" },
				{ min = 5, max = 6, text = "Calendar stones — align on solstices for power" },
			} },
		{ min = 20, max = 20, name = "Barbarian camp",
			developments = {
				{ min = 1, max = 2, text = "Hiding a great treasure" },
				{ min = 3, max = 4, text = "Preparing for war — hundreds of warriors" },
				{ min = 5, max = 6, text = "Peaceful traders, unfairly called barbarians" },
			} },
	},
}

return M
