local wezterm = require 'wezterm'

return {
	-- color_scheme = 'Sonokai (Gogh)',
	-- color_scheme = 'Ayu Mirage',
	-- color_scheme = 'Apprentice (base16)',
	-- color_scheme = 'Tomorrow Night',
	-- color_scheme = 'mellow',
	color_scheme = 'Catppuccin Mocha',
	use_fancy_tab_bar = false,
	window_decorations = 'RESIZE',
	font = wezterm.font 'JetBrains Mono',
	font_size = 14,
	harfbuzz_features = { 'calt=0' }, -- Disable ligatures for -> and |> and maybe others

	leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 },
	keys = {
		{
			key = 'Enter',
			mods = 'LEADER',
			action = wezterm.action.ActivateCopyMode
		}
	}
}
