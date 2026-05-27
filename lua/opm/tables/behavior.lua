local M = {}

M.behavior_context = {
	name = "Character Behavior Context",
	type = "range",
	dice = "1d100",
	entries = {
		{ min = 1, max = 10, result = "Based on Identity Keywords" },
		{ min = 11, max = 20, result = "Based on Mind Keywords" },
		{ min = 21, max = 30, result = "Based on Body Keywords" },
		{ min = 31, max = 40, result = "Based on Talent Keywords" },
		{ min = 41, max = 45, result = "Helps themself" },
		{ min = 46, max = 50, result = "Is helpful" },
		{ min = 51, max = 55, result = "Causes harm" },
		{ min = 56, max = 60, result = "Gives something, item or information" },
		{ min = 61, max = 65, result = "Opposes PC" },
		{ min = 66, max = 70, result = "Seeks something" },
		{ min = 71, max = 75, result = "Protects something" },
		{ min = 76, max = 80, result = "Expresses an emotion" },
		{ min = 81, max = 85, result = "Is confused or undecided" },
		{ min = 86, max = 90, result = "Acts strangely or unexpectedly" },
		{ min = 91, max = 95, result = "Tries to take something" },
		{ min = 96, max = 100, result = "Tries to end the encounter" },
	},
}

return M