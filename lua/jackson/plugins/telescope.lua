local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end
local builtin = require("telescope.builtin")

local trouble_status, trouble = pcall(require, "trouble.providers.telescope")

if not trouble_status then
	print("Trouble_status not ok")
	return
end
local action_state = require("telescope.actions.state")
vim.keymap.set(
	"n",
	"<C-b>",
	"<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
	{ noremap = true, silent = true }
)

telescope.load_extension("fzf")
telescope.load_extension("media_files")
telescope.load_extension("persisted")
telescope.load_extension("live_grep_args")

local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		initial_mode = "insert",
		layout_config = {
			prompt_position = "top",
		},
		prompt_prefix = " ",
		selection_caret = " ",
		path_display = { "smart" },
		mappings = {
			i = {
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,

				["<esc>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				-- ["<CR>"] = actions.select_default + actions.center,
				--
				["<CR>"] = function(pb)
					local picker = action_state.get_current_picker(pb)
					local multi = picker:get_multi_selection()
					actions.select_default(pb) -- the normal enter behaviour
					for _, j in pairs(multi) do
						if j.path ~= nil then -- is it a file -> open it as well:
							vim.cmd(string.format("%s %s", "edit", j.path))
						end
					end
				end,

				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,

				-- ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_loclist,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
				["<C-t>"] = trouble.open_selected_with_trouble,
			},

			n = {
				["<CR>"] = function(pb)
					local picker = action_state.get_current_picker(pb)
					local multi = picker:get_multi_selection()
					actions.select_default(pb) -- the normal enter behaviour
					for _, j in pairs(multi) do
						if j.path ~= nil then -- is it a file -> open it as well:
							vim.cmd(string.format("%s %s", "edit", j.path))
						end
					end
				end,
				["<esc>"] = actions.close,
				-- ["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = trouble.open_selected_with_trouble,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["?"] = actions.which_key,
			},
		},
	},
	pickers = {
		-- Default configuration for builtin pickers goes here:
		-- picker_name = {
		--   picker_config_key = value,
		--   ...
		-- }
		colorscheme = {
			enable_preview = true,
		},
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
	},
	extensions = {
		-- Your extension configuration goes here:
		-- extension_name = {
		--   extension_config_key = value,
		-- }
		-- please take a look at the readme of the extension you want to configure
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
		persisted = {
			layout_config = {
				width = 0.5,
				height = 0.5,
				prompt_position = "top",
			},
		},
	},
})

function Find_git_diff_files()
	local branches = { "upstream/master", "origin/master" }
	local output = {}

	local project_root = vim.fn.getcwd()

	for _, branch in ipairs(branches) do
		local cmd = string.format("git diff --name-only --diff-filter=d %s", branch)
		local branch_output = vim.fn.systemlist(cmd, project_root)

		if vim.v.shell_error == 0 then
			for _, file in ipairs(branch_output) do
				local abs_path = project_root .. "/" .. file
				if vim.fn.filereadable(abs_path) == 1 then
					table.insert(output, abs_path)
				end
			end
		end
	end

	if #output == 0 then
		print("No Git-tracked files with changes from the specified branches.")
		return
	end

	-- Use the list of files as input for a custom Telescope picker
	require("telescope.pickers")
		.new({}, {
			prompt_title = "Git Diff Files",
			finder = require("telescope.finders").new_table({
				results = output,
			}),
			sorter = require("telescope.config").values.file_sorter({}),
		})
		:find()
end

vim.api.nvim_set_keymap("n", "<leader>fj", "<cmd>lua Find_git_diff_files()<cr>", { noremap = true })
