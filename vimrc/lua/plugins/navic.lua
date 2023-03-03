-- plugin: navic.nvim
-- see: https://github.com/SmiteshP/nvim-navic

local ok, navic = pcall(require, 'nvim-navic')

local colors = require('core').get_colors()

-- Highlight table
local highlights = {
	NavicIconsFile          = {fg = colors.red},
	NavicIconsModule        = {fg = colors.olivedrab},
	NavicIconsNamespace     = {fg = colors.orange},
	NavicIconsPackage       = {fg = colors.olivedrab},
	NavicIconsClass         = {fg = colors.orange},
	NavicIconsMethod        = {fg = colors.blue},
	NavicIconsProperty      = {fg = colors.blue},
	NavicIconsField         = {fg = colors.blue},
	NavicIconsConstructor   = {fg = colors.red},
	NavicIconsEnum          = {fg = colors.cyan},
	NavicIconsInterface     = {fg = colors.yellow},
	NavicIconsFunction      = {fg = colors.blue},
	NavicIconsVariable      = {fg = colors.base1},
	NavicIconsConstant      = {fg = colors.cyan},
	NavicIconsString        = {fg = colors.cyan},
	NavicIconsNumber        = {fg = colors.cyan},
	NavicIconsBoolean       = {fg = colors.cyan},
	NavicIconsArray         = {fg = colors.yellow},
	NavicIconsObject        = {fg = colors.yellow},
	NavicIconsKey           = {fg = colors.base1},
	NavicIconsNull          = {fg = colors.cyan},
	NavicIconsEnumMember    = {fg = colors.cyan},
	NavicIconsStruct        = {fg = colors.yellow},
	NavicIconsEvent         = {fg = colors.cyan},
	NavicIconsOperator      = {fg = colors.olivedrab},
	NavicIconsTypeParameter = {fg = colors.base1},
	NavicText               = {fg = colors.base1},
	NavicSeparator          = {fg = colors.rosefenicottero},
}

local M = {}

function M.setup()
  if not ok then
    return
  end

  -- Set highlights
  for name, color in pairs(highlights) do
    vim.api.nvim_set_hl(0, name, {
      fg = color.fg,
    })
  end

  navic.setup {
    highlight = true,
  }
end

function M.get_location()
  if not ok then
    return ''
  end
  return navic.get_location()
end

function M.is_available()
  if not ok then
    return false
  end
  return navic.is_available()
end

return M
