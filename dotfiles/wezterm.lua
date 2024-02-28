-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Everforest Dark (Gogh)'

config.font = wezterm.font 'Fira Code Nerd Font'

-- Tab bar stuff
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Window stuff
config.window_background_opacity = 0.9

-- and finally, return the configuration to wezterm
return config
