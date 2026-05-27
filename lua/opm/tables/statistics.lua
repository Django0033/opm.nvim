local M = {}

M.statistics = {
	name = "Creature Statistics",
	type = "range",
	dice = "1d10",
	entries = {
		{ min = 1, max = 1, result = "About 50% lower" },
		{ min = 2, max = 3, result = "About 25% lower" },
		{ min = 4, max = 7, result = "What you expect" },
		{ min = 8, max = 9, result = "About 25% higher" },
		{ min = 10, max = 10, result = "About 50% higher" },
	},
}

return M
