local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local helpers = require("global.helpers")

local icon = wibox.container.background(
	wibox.widget {
		font = beautiful.icon_fonts .. " 22",
		markup = helpers.colorize_text("墳", beautiful.accent_normal),
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox
	},
	beautiful.transparent,
	gears.shape.rectangle
)

local osd_header = wibox.widget {
	text = 'Volume',
	font = 'Roboto Bold 12',
	align = 'left',
	valign = 'center',
	widget = wibox.widget.textbox
}

local osd_value = wibox.widget {
	text = '0%',
	font = 'Roboto Bold 12',
	align = 'center',
	valign = 'center',
	widget = wibox.widget.textbox
}

local slider_osd = wibox.widget {
	nil,
	{
		id = 'vol_osd_slider',
		bar_shape = gears.shape.rounded_rect,
		bar_height = dpi(2),
		bar_color = '#ffffff20',
		bar_active_color = beautiful.accent_normal .. "80",
		handle_color = beautiful.accent_normal,
		handle_shape = gears.shape.circle,
		handle_width = dpi(15),
		handle_border_color = '#00000012',
		handle_border_width = dpi(1),
		maximum = 150,
		widget = wibox.widget.slider
	},
	nil,
	expand = 'none',
	layout = wibox.layout.align.vertical
}

local vol_osd_slider = slider_osd.vol_osd_slider



local update_icon = function(volume_level)
	awful.spawn.easy_async_with_shell(
		[[pactl get-sink-mute 0]], function(stdout)
		if stdout:match("no") then
			if volume_level <= 50 and volume_level > 0 then
				icon.widget.markup = helpers.colorize_text("", beautiful.accent_normal)
			elseif volume_level <= 100 and volume_level > 50 then
				icon.widget.markup = helpers.colorize_text("", beautiful.accent_normal)
			elseif volume_level <= 150 and volume_level > 100 then
				icon.widget.markup = helpers.colorize_text("", beautiful.accent_normal)
			end
		elseif stdout:match("yes") then
			icon.widget.markup = helpers.colorize_text("ﱝ", beautiful.accent_normal)
		end
	end
	)
	icon:emit_signal("widget::redraw_needed")
end

vol_osd_slider:connect_signal(
	'property::value',
	function()
		local volume_level = vol_osd_slider:get_value()

		awful.spawn('pactl set-sink-volume 0 ' .. volume_level .. '%', false)

		-- Update textbox widget text
		osd_value.text = volume_level .. '%'

		-- Update the volume slider if values here change
		awesome.emit_signal('widget::volume:update', volume_level)

		if awful.screen.focused().show_vol_osd then
			awesome.emit_signal('module::volume_osd:show', true)
		end

		update_icon(volume_level)
	end
)

vol_osd_slider:connect_signal(
	'button::press',
	function()
		awful.screen.focused().show_vol_osd = true
	end
)

vol_osd_slider:connect_signal(
	'mouse::enter',
	function()
		awful.screen.focused().show_vol_osd = true
	end
)

-- The emit will come from the volume-slider
awesome.connect_signal(
	'module::volume_osd',
	function(volume)
		vol_osd_slider:set_value(volume)
		update_icon(volume)
	end
)

local volume_slider_osd = wibox.widget {
	icon,
	slider_osd,
	spacing = dpi(24),
	layout = wibox.layout.fixed.horizontal
}

local osd_height = dpi(100)
local osd_width = dpi(300)
local osd_margin = dpi(10)

screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		local s = s or {}
		s.show_vol_osd = false

		-- Create the box
		s.volume_osd_overlay = awful.popup {
			widget = {
				-- Removing this block will cause an error...
			},
			ontop = true,
			visible = false,
			type = 'notification',
			screen = s,
			height = osd_height,
			width = osd_width,
			maximum_height = osd_height,
			maximum_width = osd_width,
			offset = dpi(5),
			shape = gears.shape.rectangle,
			bg = beautiful.transparent,
			preferred_anchors = 'middle',
			preferred_positions = { 'left', 'right', 'top', 'bottom' }
		}

		s.volume_osd_overlay:setup {
			{
				{
					{
						layout = wibox.layout.align.horizontal,
						expand = 'none',
						forced_height = dpi(48),
						osd_header,
						nil,
						osd_value
					},
					volume_slider_osd,
					layout = wibox.layout.fixed.vertical
				},
				left = dpi(24),
				right = dpi(24),
				widget = wibox.container.margin
			},
			bg = beautiful.background,
			shape = gears.shape.rounded_rect,
			widget = wibox.container.background()
		}

		-- Reset timer on mouse hover
		s.volume_osd_overlay:connect_signal(
			'mouse::enter',
			function()
				awful.screen.focused().show_vol_osd = true
				awesome.emit_signal('module::volume_osd:rerun')
			end
		)
	end
)

local hide_osd = gears.timer {
	timeout   = 2,
	autostart = true,
	callback  = function()
		local focused = awful.screen.focused()
		focused.volume_osd_overlay.visible = false
		focused.show_vol_osd = false
	end
}

awesome.connect_signal(
	'module::volume_osd:rerun',
	function()
		if hide_osd.started then
			hide_osd:again()
		else
			hide_osd:start()
		end
	end
)

local placement_placer = function()
	local focused = awful.screen.focused()

	local right_panel = focused.right_panel
	local left_panel = focused.left_panel
	local volume_osd = focused.volume_osd_overlay

	if right_panel and left_panel then
		if right_panel.visible then
			awful.placement.bottom_left(
				volume_osd,
				{
					margins = {
						left = osd_margin,
						right = 0,
						top = 0,
						bottom = osd_margin
					},
					honor_workarea = true
				}
			)
			return
		end
	end

	if right_panel then
		if right_panel.visible then
			awful.placement.bottom_left(
				volume_osd,
				{
					margins = {
						left = osd_margin,
						right = 0,
						top = 0,
						bottom = osd_margin
					},
					honor_workarea = true
				}
			)
			return
		end
	end

	awful.placement.bottom_right(
		volume_osd,
		{
			margins = {
				left = 0,
				right = osd_margin,
				top = 0,
				bottom = osd_margin,
			},
			honor_workarea = true
		}
	)
end

awesome.connect_signal(
	'module::volume_osd:show',
	function(bool)
		placement_placer()
		awful.screen.focused().volume_osd_overlay.visible = bool
		if bool then
			awesome.emit_signal('module::volume_osd:rerun')
			awesome.emit_signal(
				'module::brightness_osd:show',
				false
			)
		else
			if hide_osd.started then
				hide_osd:stop()
			end
		end
	end
)
