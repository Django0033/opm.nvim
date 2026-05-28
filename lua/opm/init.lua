local M = {}

M.config = require("opm.config")
M.dice = require("opm.dice")
M.fate = require("opm.fate")
M.meaning = require("opm.meaning")
M.ui = require("opm.ui")
function M.setup(opts)
	opts = opts or {}
	M.config.setup(opts)
	M.dice.setup()
	M._setup_keymaps()
end

function M._setup_keymaps()
	local keymaps = M.config.get().keymaps
	local commands = {
		picker              = { "Opm", "Open command picker" },
		fate                = { "OpmFate", "Ask Fate oracle" },
		action              = { "OpmAction", "Roll action words" },
		description         = { "OpmDescription", "Roll description words" },
		character           = { "OpmCharacter", "Generate character" },
		character_behavior  = { "OpmCharacterBehavior", "Character behavior" },
		creature            = { "OpmCreature", "Generate creature" },
		creature_behavior   = { "OpmCreatureBehavior", "Creature behavior" },
		adventure           = { "OpmAdventure", "Generate adventure" },
		mystery_check       = { "OpmMysteryCheck", "Mystery check" },
		mystery_descriptor  = { "OpmMysteryDescriptor", "Mystery descriptor" },
		location_area       = { "OpmLocArea", "Roll area elements" },
		location_descriptor = { "OpmLocDescriptor", "Roll location descriptors" },
		location_exits      = { "OpmLocExit", "Roll connector exits" },
	}
	for name, entry in pairs(commands) do
		local lhs = keymaps[name]
		if lhs and lhs ~= false then
			vim.keymap.set("n", lhs, ":" .. entry[1] .. "<CR>", {
				silent = true,
				desc = entry[2],
			})
		end
	end

	if keymaps.expand and keymaps.expand ~= false then
		vim.keymap.set("n", keymaps.expand, function()
			require("opm.expand").expand_current_line()
		end, { silent = true, desc = "Expand template on current line" })
	end

	if keymaps.expand_fate and keymaps.expand_fate ~= false then
		vim.keymap.set("n", keymaps.expand_fate, function()
			require("opm.expand").expand_fate()
		end, { silent = true, desc = "Expand Fate question on current line" })
	end
end

return M
