local M = {}

local ERROR_PREFIX = require("opm.constants").ERROR_PREFIX .. " "
local active_windows, window_content, window_target_bufnr = {}, {}, {}

function M.show_result(title, lines, opts)
	opts = opts or {}
	M.close()
	lines = type(lines) == "string" and vim.split(lines, "\n", { trimempty = true }) or lines
	local content = vim.deepcopy(lines)
	local can_insert = M.can_insert_here()
	if title then
		content = vim.list_extend({ title, string.rep("─", 40) }, lines)
	end
	table.insert(content, "")
	table.insert(content, "  Press 'q' to close | 'y' to copy")
	if can_insert then
		table.insert(content, "  Press <CR> to insert")
	end
	return M.open(content, {
		title = opts.title or "Result",
		insert_content = opts.insert_text or (lines and #lines > 0 and vim.deepcopy(lines)),
		target_bufnr = can_insert and vim.api.nvim_get_current_buf() or nil,
	})
end

function M.copy_result(win_id)
	local content = window_content[win_id]
	if not content then
		vim.notify(ERROR_PREFIX .. "No content to copy", vim.log.levels.WARN)
		return
	end
	local text = type(content) == "string" and content or table.concat(content, "\n")
	vim.fn.setreg("+", text)
	vim.notify(ERROR_PREFIX .. "Copied to clipboard", vim.log.levels.INFO)
end

function M.insert_result(win_id)
	local content = window_content[win_id]
	if not content then
		vim.notify(ERROR_PREFIX .. "No content to insert", vim.log.levels.WARN)
		return
	end
	local target_bufnr = window_target_bufnr[win_id]
	if not target_bufnr then
		vim.notify(ERROR_PREFIX .. "Could not find target buffer", vim.log.levels.ERROR)
		return
	end
	local target_winid = vim.fn.bufwinid(target_bufnr)
	if target_winid == -1 then
		vim.notify(ERROR_PREFIX .. "Could not find target window", vim.log.levels.ERROR)
		return
	end

	local text = type(content) == "string" and content or table.concat(content, "\n")
	vim.fn.setreg("+", text)
	vim.notify(ERROR_PREFIX .. "Copied to clipboard", vim.log.levels.INFO)

	M.close(win_id)

	vim.api.nvim_set_current_win(target_winid)
	vim.cmd('normal! "+p')
end

function M.can_insert_here()
	return vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()):match("%.md$") ~= nil
end

function M.open(content, opts)
	opts = opts or {}
	if type(content) == "string" then
		content = vim.split(content, "\n", { trimempty = true })
	end
	local cfg = require("opm.config").get().float
	local win_w, win_h = vim.o.columns, vim.o.lines
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = math.floor(win_w * cfg.width),
		height = math.floor(win_h * cfg.height),
		row = math.floor((win_h - win_h * cfg.height) / 2),
		col = math.floor((win_w - win_w * cfg.width) / 2),
		style = "minimal",
		border = cfg.border,
		title = opts.title,
	})
	if opts.focus ~= false then
		vim.api.nvim_set_current_win(win)
	end
	if opts.insert_content then
		window_content[win] = type(opts.insert_content) == "string"
			and opts.insert_content
			or table.concat(opts.insert_content, "\n")
	end
	vim.keymap.set("n", "q", function() M.close(win) end, { buffer = buf, nowait = true, silent = true })
	vim.keymap.set("n", "<Esc>", function() M.close(win) end, { buffer = buf, nowait = true, silent = true })
	vim.keymap.set("n", "y", function() M.copy_result(win) end, { buffer = buf, nowait = true, silent = true })
	vim.keymap.set("n", "Y", function() M.copy_result(win) end, { buffer = buf, nowait = true, silent = true })
	if opts.insert_content then
		window_target_bufnr[win] = opts.target_bufnr
		vim.keymap.set("n", "<CR>", function() M.insert_result(win) end, { buffer = buf, noremap = true, silent = true })
		vim.keymap.set("n", "<Enter>", function() M.insert_result(win) end, { buffer = buf, noremap = true, silent = true })
	end
	table.insert(active_windows, win)
	return buf, win
end

function M.close(win_id)
	if win_id then
		if vim.api.nvim_win_is_valid(win_id) then
			vim.api.nvim_win_close(win_id, true)
		end
		for i, w in ipairs(active_windows) do
			if w == win_id then
				table.remove(active_windows, i)
				window_content[w] = nil
				window_target_bufnr[w] = nil
				break
			end
		end
	else
		for _, win in ipairs(active_windows) do
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			window_content[win] = nil
			window_target_bufnr[win] = nil
		end
		active_windows = {}
	end
end

return M
