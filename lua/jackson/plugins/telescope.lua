local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local lga_actions = require("telescope-live-grep-args.actions")

telescope.load_extension("fzf")
telescope.load_extension("persisted")
telescope.load_extension("live_grep_args")

telescope.setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    sorting_strategy = "ascending",
    initial_mode = "insert",
    layout_config = {
      prompt_position = "top",
      horizontal = {
        width_padding = 0.1,
        height_padding = 0.1,
        preview_width = 0.6, -- Adjust this value to make the preview window wider
      },
      vertical = {
        width_padding = 0.05,
        height_padding = 1,
        preview_height = 0.5, -- Adjust this value to make the preview window taller
      }
    },
    prompt_prefix = " ",
    selection_caret = " ",
    -- path_display = { "smart" },
    path_display = { "truncate" },
    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<esc>"] = actions.close,

        ["<C-k>"] = lga_actions.quote_prompt({ postfix = " --iglob !**/*_spec.rb --no-ignore" }),
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = function(pb)
          local picker = action_state.get_current_picker(pb)
          local multi = picker:get_multi_selection()
          actions.select_default(pb) -- the normal enter behaviour
          for _, j in pairs(multi) do
            if j.path ~= nil then    -- is it a file -> open it as well:
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

        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.send_selected_to_loclist + actions.open_loclist,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<CR>"] = function(pb)
          local picker = action_state.get_current_picker(pb)
          local multi = picker:get_multi_selection()
          actions.select_default(pb) -- the normal enter behaviour
          for _, j in pairs(multi) do
            if j.path ~= nil then    -- is it a file -> open it as well:
              vim.cmd(string.format("%s %s", "edit", j.path))
            end
          end
        end,
        ["<esc>"] = actions.close,
        ["q"] = actions.close,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.send_selected_to_loclist + actions.open_loclist,

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

        ["<C-p>"] = actions.results_scrolling_up,
        ["<C-n>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
    pickers = {
      colorscheme = {
        enable_preview = true,
      },
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    fzf = {
      fuzzy = true,                   -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
    persisted = {
      layout_config = {
        width = 0.8,
        height = 0.5,
        prompt_position = "top",
      },
    },
  },
})
