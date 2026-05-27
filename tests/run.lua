-- Minimal Neovim init for running tests
-- Adds source and test directories to runtime path
-- So require("opm") and require("test_mythic") work

local cwd = vim.fn.getcwd()

-- Add project root to runtime path (for lua/ and plugin/)
vim.cmd("set rtp+=" .. cwd)

-- Add tests/ to lua search path (for helper module)
package.path = cwd .. "/tests/?.lua;" .. package.path

-- Load and run tests
print("Running tests...")
require("test_mythic")

-- Print summary
_print_summary()

-- Quit
vim.cmd("qa")
