-- Pull in the wezterm API
local wezterm = require 'wezterm'

local act = wezterm.action
-- This will hold the configuration
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.color_scheme = 'Gruvbox dark, soft (base16)'
config.leader = { key = 'q', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- This will create a new split and run your default program inside it
  {
    key = '-',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'x',
    mods = 'LEADER',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'h',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Down',
  },
  {
    key = 'Z',
    mods = 'CTRL',
    action = wezterm.action.TogglePaneZoomState,
  },
  { key = '	', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = '	', mods = 'CTRL', action = act.ActivateTabRelative(1) },
}
return config
