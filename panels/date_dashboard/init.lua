local gears = require "gears"
local awful = require "awful"
local wibox = require "wibox"

local beautiful = require "beautiful"
local dpi = beautiful.xresources.apply_dpi

local helpers = require "global.helpers"

local calender = require "panels.date_dashboard.calender"
local weather = require "widget.weather.weather_icon"
local calender_box = helpers.create_boxed_widget(calender, dpi(270), dpi(340), beautiful.widget_bg_normal)
local weather_box = helpers.create_boxed_widget(weather, dpi(270), dpi(40), beautiful.widget_bg_normal)
local date_dashboard = {}

date_dashboard.create = function(s)
	local panel = awful.popup {
		ontop = true,
		screen = s,
		visible = false,
		type = "dock",
		minimum_height = beautiful.date_dashboard_min_height,
		maximum_height = beautiful.date_dashboard_max_height,
		minimum_width = beautiful.date_dashboard_min_width,
		maximum_width = beautiful.date_dashboard_max_width,
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		shape = helpers.prrect(dpi(12), true, true, true, true),
		placement = function(w)
			awful.placement.top_right(w, {
				margins = { bottom = dpi(5), top = beautiful.wibar_height + dpi(5), left = dpi(5), right = dpi(5) },
			})
		end,
		widget = {
			{
				{
					weather_box,
					calender_box,
					spacing = dpi(20),
					layout = wibox.layout.fixed.vertical,
					widget = wibox.container.margin
				},
				margins = dpi(16),
				widget = wibox.container.margin
			},
			shape = helpers.prrect(beautiful.widget_box_radius * 2, true, true, false, false),
			bg = beautiful.bg_normal,
			widget = wibox.container.background
		},
		layout = wibox.layout.align.vertical
	}

	panel.opened = false

	awesome.connect_signal("date_dashboard::toggle", function(scr)
		if scr == s then
			s.date_dashboard.visible = not s.date_dashboard.visible
			awesome.emit_signal("dashboard::close", awful.screen.focused())
		end
	end)
	awesome.connect_signal("date_dashboard::close", function(scr)
		if scr == s then
			if s.date_dashboard.visible then
				s.date_dashboard.visible = not s.date_dashboard.visible
			end
		end
	end)

	return panel
end
return date_dashboard
