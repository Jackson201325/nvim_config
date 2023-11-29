local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  return
end

local terminal = require("toggleterm.terminal").Terminal

local lazygit = terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "none",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function()
    vim.cmd("startinsert!")
  end,
})

function LAZYGIT_TOGGLE()
  lazygit:toggle()
end

local npm_server = terminal:new({
  cmd = "npm run dev",
  close_on_exit = true,
  direction = "float",
  hidden = true,
})

function NPM_SERVER_TOGGLE()
  npm_server:toggle()
end

local foreman = terminal:new({
  cmd = "bundle exec foreman start web",
  close_on_exit = true,
  direction = "float",
  hidden = true,
})

function RAILS_FOREMAN_TOGGLE()
  foreman:toggle()
end

local rails_routes = terminal:new({
  cmd = "bundle exec rails routes",
  close_on_exit = false,
  direction = "float",
})

function RAILS_ROUTES_TOGGLE()
  rails_routes:toggle()
end

local rails_console = terminal:new({
  cmd = "bundle exec rails c",
  hidden = true,
  direction = "float",
  close_on_exit = true,
})

function RAILS_CONSOLE_TOGGLE()
  rails_console:toggle()
end

-- local ember_server = terminal:new({
--   -- cmd = "nvm use 14.21.1 && ember serve --proxy http://localhost:5000",
--   cmd = "source $HOME/.nvm/nvm.sh && nvm use 14.21.1 && ember serve --proxy http://localhost:5000",
--   -- close_on_exit = true,
--   close_on_exit = false,
--   hidden = true,
--   direction = "float",
-- })
--
-- function EMBER_SERVER_TOGGLE()
--   ember_server:toggle()
-- end

local byebug_server = terminal:new({
  cmd = "bundle exec byebug -R localhost:8989",
  close_on_exit = true,
  direction = "float",
  hidden = true,
})

function BYEBUG_SERVER_TOGGLE()
  byebug_server:toggle()
end

local rails_server = terminal:new({
  cmd = "bundle exec rails s",
  close_on_exit = false,
  direction = "float",
  hidden = true,
})

function RAILS_SERVER_TOGGLE()
  rails_server:toggle()
end

local docker_up = terminal:new({
  cmd = "docker-compose up",
  close_on_exit = false,
  direction = "float",
  hidden = true,
})

function DOCKER_UP_TOGGLE()
  docker_up:toggle()
end

local docker_bash = terminal:new({
  cmd = "docker-compose run --rm web bash",
  close_on_exit = false,
  direction = "float",
  hidden = true,
})

function DOCKER_BASH_TOGGLE()
  docker_bash:toggle()
end


local htop = terminal:new({ direction = "float", cmd = "htop", hidden = true })

function HTOP_TOGGLE()
  htop:toggle()
end

toggleterm.setup({
  size = 20,
  open_mapping = [[<c-t>]],
  hide_numbers = true,
  -- persist_mode = true,
  shade_filetypes = {},
  auto_scroll = false, -- automatically scroll to the bottom on terminal output
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "none",
    winblend = 0,
    highlights = {
      border = "normal",
      background = "normal",
    },
  },
})
