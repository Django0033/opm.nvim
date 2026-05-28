local M = {}

M.element = {
	name = "Location Element",
	type = "range",
	dice = "2d10 + PP",
	entries = {
		{ min = nil, max = 4, result = "None" },
		{ min = 5, max = 9, result = "Expected" },
		{ min = 10, max = 10, result = "Expected, Return" },
		{ min = 11, max = 14, result = "Random" },
		{ min = 15, max = 15, result = "Random, Hazard" },
		{ min = 16, max = 16, result = "Random, Discovery" },
		{ min = 17, max = 19, result = "Known" },
		{ min = 20, max = 20, result = "Known, Climax" },
		{ min = 21, max = 21, result = "Expected, Exit" },
		{ min = 22, max = nil, result = "Complete" },
	},
}

M.descriptor = {
	name = "Location Descriptors",
	type = "simple",
	dice = "1d100",
	entries = {
		[1] = "Abandoned", [2] = "Active", [3] = "Artistic", [4] = "Atmosphere",
		[5] = "Average", [6] = "Beautiful", [7] = "Bizarre", [8] = "Bleak",
		[9] = "Bright", [10] = "Business", [11] = "Clean", [12] = "Clue",
		[13] = "Cold", [14] = "Colorful", [15] = "Colorless",
		[16] = "Communication", [17] = "Complicated", [18] = "Consumable",
		[19] = "Container", [20] = "Cramped", [21] = "Creepy", [22] = "Crude",
		[23] = "Damaged", [24] = "Dangerous", [25] = "Dark", [26] = "Deactivated",
		[27] = "Deliberate", [28] = "Desired", [29] = "Domestic", [30] = "Empty",
		[31] = "Enclosed", [32] = "Energy", [33] = "Equipment", [34] = "Familiar",
		[35] = "Flora", [36] = "Foreign", [37] = "Forgotten", [38] = "Fortified",
		[39] = "Fragile", [40] = "Fragrant", [41] = "Friendly", [42] = "Frightening",
		[43] = "Full", [44] = "Fungal", [45] = "Guarded", [46] = "Helpful",
		[47] = "Hidden", [48] = "Important", [49] = "Impressive", [50] = "Inactive",
		[51] = "Large", [52] = "Light", [53] = "Lonely", [54] = "Loud",
		[55] = "Meaningful", [56] = "Mechanical", [57] = "Messy", [58] = "Moving",
		[59] = "Multiple", [60] = "Mundane", [61] = "Mysterious", [62] = "Natural",
		[63] = "Neglected", [64] = "Odd", [65] = "Official", [66] = "Old",
		[67] = "Open", [68] = "Ornate", [69] = "Peaceful", [70] = "Personal",
		[71] = "Portal", [72] = "Powerful", [73] = "Prized", [74] = "Protected",
		[75] = "Purposeful", [76] = "Quiet", [77] = "Rare", [78] = "Ready",
		[79] = "Reassuring", [80] = "Resource", [81] = "Rustic", [82] = "Simple",
		[83] = "Small", [84] = "Storage", [85] = "Strange", [86] = "Threat",
		[87] = "Tiny", [88] = "Tool", [89] = "Tragic", [90] = "Unpleasant",
		[91] = "Unusual", [92] = "Useful", [93] = "Valuable", [94] = "Vast",
		[95] = "Warm", [96] = "Warning", [97] = "Watery", [98] = "Weapon",
		[99] = "Welcoming", [100] = "Winding",
	},
}

return M
