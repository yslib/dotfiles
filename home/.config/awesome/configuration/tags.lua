local awful = require("awful")

--- Tags
--- ~~~~

screen.connect_signal("request::desktop_decoration", function(s)
	--- Each screen has its own tag table.
	if s.geometry.width > s.geometry.height then
		awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8" }, s, awful.layout.layouts[1])
	else
		-- portrait monitor layouts
		awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8" }, s, awful.layout.suit.tile.bottom)
	end
end)
