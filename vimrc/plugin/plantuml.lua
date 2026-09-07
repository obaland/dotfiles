if vim.fn.has('nvim') == 1 then
  local core = require('core')

  local command
  if core.is_wsl() then
      command = '/mnt/c/Program Files/Google/Chrome/Application/chrome.exe'
  elseif core.is_win() then
      command = 'C:/Program Files/Google/Chrome/Application/chrome.exe'
  end

  require('plugins.plantuml').setup({
    browser = {
      command = command,
      args = {
        '--new-window'
      }
    }
  })
end
