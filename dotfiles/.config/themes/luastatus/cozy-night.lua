-- foreground
fg_black = "^c" .. "#262643" .. "^";
fg_black0 = "^c" .. "#171728" .. "^";
fg_white = "^c" .. "#F9F3ED" .. "^";
fg_white0 = "^c" .. "#F0D1A9" .. "^";
fg_purple1 = "^c" .. "#C49DA3" .. "^";
fg_purple2 = "^c" .. "#896C9A" .. "^";
fg_purple3 = "^c" .. "#484C7D" .. "^";

-- background
bg_black = "^b" .. "#262643" .. "^";
bg_black0 = "^b" .. "#171728" .. "^";
bg_white = "^b" .. "#F9F3ED" .. "^";
bg_white0 = "^b" .. "#F0D1A9" .. "^";
bg_purple1 = "^b" .. "#C49DA3" .. "^";
bg_purple2 = "^b" .. "#896C9A" .. "^";

local color =
{
	-- set colors to modules
	sep = bg_black .. fg_black .. '|'; -- separator

	col0_ic_fg = fg_white;
	col0_ic_bg = bg_purple3;
	col0_fg = fg_white;
	col0_bg = bg_black;

	col1_ic_fg = fg_white;
	col1_ic_bg = bg_purple2;
	col1_fg = fg_white;
	col1_bg = bg_black;

	col2_ic_fg = fg_black; -- battery
	col2_ic_bg = bg_purple1;
	col2_fg = fg_white;
	col2_bg = bg_black;

  warn_bg = bg_red1;
  warn_fg = fg_white;
}

return color
