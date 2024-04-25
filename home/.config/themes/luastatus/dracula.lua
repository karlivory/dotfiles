-- foreground
fg_black0 = "^c" .. "#282a36" .. "^";
fg_black1 = "^c" .. "#44475a" .. "^";
fg_white = "^c" .. "#f8f8f2" .. "^";
fg_black2 = "^c" .. "#6272a4" .. "^";
fg_cyan = "^c" .. "#8be9fd" .. "^";
fg_green = "^c" .. "#50fa7b" .. "^";
fg_orange = "^c" .. "#ffb86c" .. "^";
fg_pink = "^c" .. "#ff79c6" .. "^";
fg_purple = "^c" .. "#bd93f9" .. "^";
fg_red = "^c" .. "#ff5555" .. "^";
fg_yellow = "^c" .. "#f1fa8c" .. "^";

-- background
bg_black0 = "^b" .. "#282a36" .. "^";
bg_black1 = "^b" .. "#44475a" .. "^";
bg_white = "^b" .. "#f8f8f2" .. "^";
bg_black2 = "^b" .. "#6272a4" .. "^";
bg_cyan = "^b" .. "#8be9fd" .. "^";
bg_green = "^b" .. "#50fa7b" .. "^";
bg_orange = "^b" .. "#ffb86c" .. "^";
bg_pink = "^b" .. "#ff79c6" .. "^";
bg_purple = "^b" .. "#bd93f9" .. "^";
bg_red = "^b" .. "#ff5555" .. "^";
bg_yellow = "^b" .. "#f1fa8c" .. "^";


local color =
{
	-- set colors to modules
	sep = bg_black0 .. fg_black0 .. '|'; -- separator

	col0_ic_fg = fg_black0;
	col0_ic_bg = bg_purple;
	col0_fg 	 = fg_purple;
	col0_bg    = bg_black0;

	col1_ic_fg = fg_black0;
	col1_ic_bg = bg_red;
	col1_fg    = fg_red;
	col1_bg    = bg_black0;

	col2_ic_fg  = fg_black0; -- battery
	col2_ic_bg  = bg_cyan;
	col2_fg     = fg_cyan;
	col2_bg     = bg_black0;
	
  warn_bg = bg_orange;
  warn_fg = fg_black0;
}

return color

