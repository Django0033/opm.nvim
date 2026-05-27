local M = {}

M.ODDS_TYPES = {
	"impossible",
	"nearly_impossible",
	"very_unlikely",
	"unlikely",
	"fifty_fifty",
	"likely",
	"very_likely",
	"nearly_certain",
	"certain",
}

M.ODDS_SHORT = {
	impossible = "Impossible",
	nearly_impossible = "Nearly Impossible",
	very_unlikely = "Very Unlikely",
	unlikely = "Unlikely",
	fifty_fifty = "50/50",
	likely = "Likely",
	very_likely = "Very Likely",
	nearly_certain = "Nearly Certain",
	certain = "Certain",
}

M.FATE_CHART = {
	impossible = { yes = { 1, 2 }, no = { 3, 10 }, exyes = { 11, 82 }, exno = { 83, 100 } },
	nearly_impossible = { yes = { 1, 3 }, no = { 4, 15 }, exyes = { 16, 83 }, exno = { 84, 100 } },
	very_unlikely = { yes = { 1, 5 }, no = { 6, 25 }, exyes = { 26, 85 }, exno = { 86, 100 } },
	unlikely = { yes = { 1, 7 }, no = { 8, 35 }, exyes = { 36, 87 }, exno = { 88, 100 } },
	fifty_fifty = { yes = { 1, 10 }, no = { 11, 50 }, exyes = { 51, 90 }, exno = { 91, 100 } },
	likely = { yes = { 1, 13 }, no = { 14, 65 }, exyes = { 66, 93 }, exno = { 94, 100 } },
	very_likely = { yes = { 1, 15 }, no = { 16, 75 }, exyes = { 76, 95 }, exno = { 96, 100 } },
	nearly_certain = { yes = { 1, 17 }, no = { 18, 85 }, exyes = { 86, 97 }, exno = { 98, 100 } },
	certain = { yes = { 1, 18 }, no = { 19, 90 }, exyes = { 91, 98 }, exno = { 99, 100 } },
}

M.ERROR_PREFIX = "opm:"

return M
