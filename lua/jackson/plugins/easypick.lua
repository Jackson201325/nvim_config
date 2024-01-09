local status_ok, easypick = pcall(require, "easypick")
if not status_ok then
	return
end

local function remote_exists(remote)
	local command = "git remote"
	local handle = io.popen(command)

	if not handle then
		return false
	end

	local result = handle:read("*a")
	handle:close()

	for line in string.gmatch(result, "[^\r\n]+") do
		if line == remote then
			return true
		end
	end

	return false
end

local function branch_exists(remote, branch)
	if not remote_exists(remote) then
		return false
	end

	local command = "git ls-remote --heads " .. remote .. " " .. branch
	local status, handle = pcall(io.popen, command)
	if not status or not handle then
		return false
	end

	local result = handle:read("*a")
	handle:close()

	return result ~= ""
end

-- Rest of your script where you use branch_exists function...

local function determine_base_branch()
	local branches = {
		{ remote = "upstream", branch = "master" },
		{ remote = "upstream", branch = "main" },
		{ remote = "origin", branch = "develop" },
		{ remote = "origin", branch = "master" },
		{ remote = "origin", branch = "main" },
	}

	for _, b in ipairs(branches) do
		if branch_exists(b.remote, b.branch) then
			return b.remote .. "/" .. b.branch
		end
	end

	return nil -- or some default branch
end

-- local base_branch = determine_base_branch()
local base_branch = "master"

easypick.setup({
	pickers = {
		-- add your custom pickers here
		-- below you can find some examples of what those can look like

		-- list files inside current folder with default previewer
		{
			-- name for your custom picker, that can be invoked using :Easypick <name> (supports tab completion)
			name = "ls",
			-- the command to execute, output has to be a list of plain text entries
			command = "ls",
			-- specify your custom previwer, or use one of the easypick.previewers
			previewer = easypick.previewers.default(),
		},

		-- diff current branch with base_branch and show files that changed with respective diffs in preview
		{
			name = "Changed Files",
			command = "git diff --name-only $(git merge-base HEAD " .. base_branch .. " )",
			previewer = easypick.previewers.branch_diff({ base_branch = base_branch }),
		},

		-- list files that have conflicts with diffs in preview
		{
			name = "conflicts",
			command = "git diff --name-only --diff-filter=U --relative",
			previewer = easypick.previewers.file_diff(),
		},
	},
})
