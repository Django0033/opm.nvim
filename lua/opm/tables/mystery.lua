local M = {}

M.check = {
	name = "Mystery Discovery Check",
	type = "range",
	dice = "1d100 + boxes",
	entries = {
		{ min = 1, max = 15, result = "Nothing useful found" },
		{ min = 16, max = 35, result = "New Suspect not connected" },
		{ min = 36, max = 50, result = "New Clue not connected" },
		{ min = 51, max = 70, result = "New Clue connected to a Suspect" },
		{ min = 71, max = 80, result = "New Suspect connected to a Clue" },
		{ min = 81, max = 100, result = "Connect existing Clue to existing Suspect" },
		{ min = 101, max = nil, result = "Definitive clue: connected Suspect is the answer" },
	},
}

M.descriptor = {
	name = "Mystery Descriptors",
	type = "simple",
	dice = "1d100",
	entries = {
		[1] = "Accident", [2] = "Aggressive", [3] = "Ambition", [4] = "Anger",
		[5] = "Attack", [6] = "Betray", [7] = "Bribe", [8] = "Business",
		[9] = "Change", [10] = "Clothing", [11] = "Code", [12] = "Communication",
		[13] = "Conflict", [14] = "Container", [15] = "Control", [16] = "Cooperation",
		[17] = "Damage", [18] = "Danger", [19] = "Deliberate", [20] = "Deny",
		[21] = "Desperate", [22] = "Discarded", [23] = "Discover", [24] = "Dispute",
		[25] = "Document", [26] = "Domicile", [27] = "Emotion", [28] = "Empty",
		[29] = "Enemy", [30] = "Equipment", [31] = "Fake", [32] = "Family",
		[33] = "Fear", [34] = "Find", [35] = "Flee", [36] = "Friend",
		[37] = "Give", [38] = "Goal", [39] = "Greed", [40] = "Group",
		[41] = "Harm", [42] = "Hate", [43] = "Help", [44] = "Helpful",
		[45] = "Hidden", [46] = "Hurt", [47] = "Inform", [48] = "Information",
		[49] = "Jealousy", [50] = "Leadership", [51] = "Legal", [52] = "Lethal",
		[53] = "Lies", [54] = "Location", [55] = "Locked", [56] = "Lost",
		[57] = "Love", [58] = "Loyal", [59] = "Mechanical", [60] = "Misfortune",
		[61] = "Missing", [62] = "Mistake", [63] = "Motive", [64] = "Mundane",
		[65] = "Mysterious", [66] = "Nature", [67] = "New", [68] = "Night",
		[69] = "NPC", [70] = "Obligation", [71] = "Old", [72] = "Partial",
		[73] = "PC", [74] = "Personal", [75] = "Plot", [76] = "Portal",
		[77] = "Possession", [78] = "Power", [79] = "Protect", [80] = "Rare",
		[81] = "Representative", [82] = "Resource", [83] = "Rumor", [84] = "Science",
		[85] = "Strange", [86] = "Surprise", [87] = "Suspicious", [88] = "Take",
		[89] = "Technology", [90] = "Threaten", [91] = "Tool", [92] = "Travel",
		[93] = "Trust", [94] = "Unusual", [95] = "Valuable", [96] = "Vehicle",
		[97] = "Vengeance", [98] = "Wealth", [99] = "Weapon", [100] = "Witness",
	},
}

return M
