-- Neovim test helper
local cwd = vim.fn.getcwd()

-- Ensure plugin source is on runtime path
vim.cmd("set rtp+=" .. cwd)

-- Mini busted-compatible test framework
local results = { pass = 0, fail = 0, errors = {} }
local current_suite = ""

_G.describe = function(name, fn)
	current_suite = name
	print("\n[" .. name .. "]")
	fn()
end

_G.it = function(name, fn)
	local ok, err = pcall(fn)
	if ok then
		results.pass = results.pass + 1
		print("  PASS: " .. name)
	else
		results.fail = results.fail + 1
		table.insert(results.errors, { suite = current_suite, test = name, error = tostring(err) })
		print("  FAIL: " .. name)
		print("        " .. tostring(err))
	end
end

_G.setup = function(fn) fn() end

-- Named _assert to avoid shadowing built-in assert()
_G._assert = {
	is_true = function(v) assert(v, "expected true, got " .. tostring(v)) end,
	is_false = function(v) assert(not v, "expected false, got " .. tostring(v)) end,
	is_not_nil = function(v) assert(v ~= nil, "expected not nil") end,
	is_string = function(v) assert(type(v) == "string", "expected string, got " .. type(v)) end,
	is_boolean = function(v) assert(type(v) == "boolean", "expected boolean, got " .. type(v)) end,
	are = {
		equal = function(a, b) assert(a == b, tostring(a) .. " != " .. tostring(b)) end,
	},
}

_G._print_summary = function()
	print("\n" .. string.rep("=", 60))
	print("RESULTS: " .. results.pass .. " passed, " .. results.fail .. " failed")
	if #results.errors > 0 then
		print("FAILURES:")
		for _, e in ipairs(results.errors) do
			print("  [" .. e.suite .. "] " .. e.test)
			print("  " .. e.error)
		end
	end
	print(string.rep("=", 60))
	if results.fail > 0 then
		vim.cmd("cq")
	end
end
