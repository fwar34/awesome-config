local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require("icons.flaticons")
local helpers = require("global.helpers")

local slider =
wibox.widget {
	nil,
	{
		id = "mic_slider",
		bar_shape = gears.shape.rounded_rect,
		bar_height = dpi(2),
		bar_color = "#ffffff20",
		bar_active_color = beautiful.accent_normal .. "80",
		handle_color = beautiful.accent_normal,
		handle_shape = gears.shape.circle,
		handle_width = dpi(15),
		handle_border_color = "#00000012",
		handle_border_width = dpi(1),
		maximum = 100,
		widget = wibox.widget.slider
	},
	nil,
	forced_height = dpi(24),
	expand = "none",
	layout = wibox.layout.align.vertical
}

local mic_slider = slider.mic_slider

-- Update on startup
local update_slider = function()
	awful.spawn.easy_async_with_shell(
		"pactl get-source-volume 0",
		function(stdout)
			local volume = string.match(stdout, "(%d?%d?%d)%%")
			mic_slider:set_value(tonumber(volume))
		end
	)
end
update_slider()

mic_slider:buttons(
	gears.table.join(
		awful.button(
			{},
			4,
			nil,
			function()
				if mic_slider:get_value() > 100 then
					mic_slider:set_value(100)
					return
				end
				mic_slider:set_value(mic_slider:get_value() + 5)
			end
		),
		awful.button(
			{},
			5,
			nil,
			function()
				if mic_slider:get_value() < 0 then
					mic_slider:set_value(0)
					return
				end
				mic_slider:set_value(mic_slider:get_value() - 5)
			end
		)
	)
)

local mic_toggle = wibox.container.background(
	helpers.imaker(icons.mic),
	beautiful.widget_bg_normal,
	gears.shape.circle
)
helpers.add_hover_cursor(mic_toggle,"hand1")

mic_toggle:connect_signal(
	"mouse::enter",
	function()
		mic_toggle.bg = beautiful.accent_normal .. "32"
	end
)
mic_toggle:connect_signal(
	"mouse::leave",
	function()
		mic_toggle.bg = beautiful.widget_bg_normal
	end
)

mic_slider:connect_signal(
	"property::value",
	function()
		local mic_level = mic_slider:get_value()
		spawn('pactl set-source-volume 0 ' .. mic_level .. '%', false)
	end
)

local update_icon = function()
	awful.spawn.easy_async_with_shell([[pactl get-source-mute 0]], function(stdout)
		if stdout:match("no") then
			mic_toggle.widget = helpers.imaker(icons.mic_mute)
		elseif stdout:match("yes") then
			mic_toggle.widget = helpers.imaker(icons.mic)
		end
	end)
	mic_toggle:emit_signal("widget::redraw_needed")
end
-- update on startup
update_icon()

local mic_button = function()
	awful.spawn.easy_async_with_shell([[bash -c "pactl set-source-mute 0 toggle"]], function()
		update_icon()
	end)
end

mic_toggle:buttons(
	awful.util.table.join(
		awful.button(
			{},
			1,
			nil,
			function()
				mic_button()
			end
		),
		awful.button(
			{},
			3,
			nil,
			function()
				awful.spawn(apps.soundctrlpanel)
			end
		)
	)
)

local volume_setting =
wibox.widget {
	{
		{
			mic_toggle,
			top = dpi(12),
			bottom = dpi(12),
			widget = wibox.container.margin
		},
		slider,
		spacing = dpi(24),
		layout = wibox.layout.fixed.horizontal
	},
	left = dpi(24),
	right = dpi(24),
	forced_height = dpi(48),
	widget = wibox.container.margin
}

return volume_setting
