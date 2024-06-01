local core = require('core')
local health = vim.health


local function check_command(command)
  if vim.fn.executable(command.name) == 1 then
    local msg = ('%s - Executable (%s)'):format(command.name, vim.fn.exepath(command.name))
    health.ok(msg)
  end

  local guide
  if core.is_win() then
    guide = command.guide_win
  elseif core.is_mac() then
    guide = command.guide_mac
  else
    guide = command.guide_unix
  end
  health.warn(
    command.name .. ' - Not Executable',
    {
      command.desc,
      ('Please install. (e.g. %s)'):format(guide)
    }
  )
end

local function check_required()
  -- git command
  local git = {
    name = 'git',
    desc = 'Version control system',
    guide_win = 'choco install git',
    guide_mac = 'brew install git',
    guide_unix = 'apt install git',
  }
  check_command(git)
end

local function check_configuration()
  local configs = {}

  if core.is_win() then
    configs['$VIM_PYTHON_PROG_ROOT'] = 'the Root direcotry path of python2 executable program.'
    configs['$VIM_PYTHON3_PROG_ROOT'] = 'the Root direcotry path of python3 executable program.'
  end

  for key, desc in pairs(configs) do
    if vim.fn.exists(key) == 1 then
      local msg = ('%s - Set (%s)'):format(key, vim.fn.expand(key))
      health.ok(msg)
    else
      health.warn(key .. ' - Not set', { desc })
    end
  end
end

local function check_commands()
  local commands = {}

  -- ripgrep
  table.insert(commands, {
    name = 'rg',
    desc = 'ripgrep combines the usability of The Silver Searcher with the raw speed of grep',
    guide_win = 'choco install ripgrep',
    guide_mac = 'brew install ripgrep',
    guide_unix = 'apt install ripgrep',
  })

  -- The Silver Searcher
  table.insert(commands, {
    name = 'ag',
    desc = 'The Silver Searcher is like grep or ack, except faster',
    guide_win = 'choco install ag',
    guide_mac = 'brew install ag',
    guide_unix = 'apt install silversearcher-ag',
  })

  for _, command in ipairs(commands) do
    check_command(command)
  end
end

local checks = {
  Required = check_required,
  Configuration = check_configuration,
  Command = check_commands
}

for name, check in pairs(checks) do
  health.start(name)
  check()
end
