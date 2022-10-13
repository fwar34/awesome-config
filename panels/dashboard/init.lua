-- ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗
-- ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗
-- ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║
-- ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║
-- ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝
-- ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local mat_icon_button_rect = require("widget.icon-button.icon-button-rect")
local mat_icon = require("widget.icon-button.icon")

local helpers = require("global.helpers")

-- define module table
local dashboard = {}

-- =========================================================
-- ===================== icons init ========================
-- =========================================================

-- --- Creating Buttons ------
local places_icon_dir = gears.filesystem.get_configuration_dir() .. "icons/places/"
local home = mat_icon_button_rect(mat_icon(places_icon_dir .. "home.svg", dpi(22)))
local Documents = mat_icon_button_rect(mat_icon(places_icon_dir .. "documents.svg", dpi(22)))
local Downloads = mat_icon_button_rect(mat_icon(places_icon_dir .. "downloads.svg", dpi(22)))
local Pictures = mat_icon_button_rect(mat_icon(places_icon_dir .. "pictures.svg", dpi(22)))
local Music = mat_icon_button_rect(mat_icon(places_icon_dir .. "music.svg", dpi(22)))
local Videos = mat_icon_button_rect(mat_icon(places_icon_dir .. "videos.svg", dpi(22)))
local Root = mat_icon_button_rect(mat_icon(places_icon_dir .. "root.svg", dpi(22)))
local Trash = mat_icon_button_rect(mat_icon(places_icon_dir .. "trash.svg", dpi(22)))
helpers.bmaker(home, "xdg-open $(xdg-user-dir)")
helpers.bmaker(Documents, "xdg-open $(xdg-user-dir DOCUMENTS)")
helpers.bmaker(Downloads, "xdg-open $(xdg-user-dir DOWNLOADS)")
helpers.bmaker(Pictures, "xdg-open $(xdg-user-dir PICTURES)")
helpers.bmaker(Music, "xdg-open $(xdg-user-dir MUSIC)")
helpers.bmaker(Videos, "xdg-open $(xdg-user-dir VIDEOS)")
helpers.bmaker(Root, "gio open /")
helpers.bmaker(Trash, "gio open trash:///")

--  Placing Buttons into Containers
--places
local places_widget =
    wibox.widget {
    {
        helpers.horizontal_pad(dpi(10)),
        home,
        Downloads,
        Documents,
        Root,
        spacing = dpi(12),
        forced_height = dpi(50),
        widget = wibox.container.margin,
        layout = wibox.layout.fixed.horizontal
    },
    {
        helpers.horizontal_pad(dpi(10)),
        Pictures,
        Music,
        Videos,
        Trash,
        spacing = dpi(12),
        widget = wibox.container.margin,
        forced_height = dpi(50),
        layout = wibox.layout.fixed.horizontal
    },
    margins = dpi(12),
    widget = wibox.container.margin,
    layout = wibox.layout.fixed.vertical
}

--importing stuff
-- local calender = require("panels.dashboard.calender")
local playerctl = require("widget.playerctl")
local audio = require("panels.dashboard.set-audio-sink")
local wifi = require ("panels.dashboard.wifi")
local bluetooth = require("panels.dashboard.bluetooth")
local night_light = require("panels.dashboard.night_light")
local user_profile = require("widget.user-profile")
local sysmon = require("panels.dashboard.system_monitor")
local volume_bar = require("widget.volume-slider")
local mic_bar = require("widget.microphone-slider")
local brightness_bar = require("widget.brightness-slider")
-- local airplane = require("")
-- local microphone = require("")
-- local search_box = require("")
local settings_widget =
    wibox.widget {
    {
        volume_bar,
        widget = wibox.container.margin,
        forced_height = dpi(45),
        layout = wibox.layout.fixed.horizontal
    },
    {
        mic_bar,
        widget = wibox.container.margin,
        forced_height = dpi(45),
        layout = wibox.layout.fixed.horizontal
    },
    {
        brightness_bar,
        widget = wibox.container.margin,
        forced_height = dpi(45),
        layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical
}
--toggle apps
local toggle_buttons =
    wibox.widget {
    {
        helpers.horizontal_pad(dpi(24)),
        wifi,
        bluetooth,
        audio,
        night_light,
        spacing = dpi(12),
        forced_height = dpi(40),
        widget = wibox.container.margin,
        layout = wibox.layout.fixed.horizontal
    },
    -- {
    --     helpers.horizontal_pad(dpi(24)),
    --     widget = wibox.container.margin,
    --     spacing = dpi(12),
    --     forced_height = dpi(40),
    --     layout = wibox.layout.fixed.horizontal
    -- },
    spacing = dpi(5),
    margins = dpi(12),
    widget = wibox.container.margin,
    layout = wibox.layout.fixed.vertical
}

-- placing them in boxes
local places_widget_box = helpers.create_boxed_widget(places_widget, dpi(270), dpi(120), beautiful.widget_bg_normal)
local volume_box = helpers.create_boxed_widget(settings_widget, dpi(270), dpi(150), beautiful.widget_bg_normal)
local user_system_monitor = helpers.create_boxed_widget(sysmon, dpi(270), dpi(120), beautiful.widget_bg_normal)
local toggle_apps = helpers.create_boxed_widget(toggle_buttons, dpi(270), dpi(60), beautiful.widget_bg_normal)
-- local calender_box = helpers.create_boxed_widget(calender, dpi(270), dpi(400), beautiful.widget_bg_normal)
-- =========================================================
-- ======================== PANEL ==========================
-- =========================================================

dashboard.create = function(s)
    local panel =
        awful.popup {
        ontop = true,
        screen = s,
        visible = false,
        type = "dock",
        minimum_height = beautiful.dashboard_min_height,
        maximum_height = beautiful.dashboard_max_height,
        minimum_width = beautiful.dashboard_min_width,
        maximum_width = beautiful.dashboard_max_width,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal,
        shape = helpers.prrect(dpi(12), true, true, true, true),
        placement = function(w)
            awful.placement.top_right(
                w,
                {
                    margins = {bottom = dpi(5), top = beautiful.wibar_height + dpi(5), left = dpi(5), right = dpi(5)}
                }
            )
        end,
        widget = {
            {
                {
                    {
                        nil,
                        {
                            {
                                {
                                    user_profile,
                                    user_system_monitor,
                                    -- calender_box,
                                    places_widget_box,
                                    spacing = dpi(15),
                                    layout = wibox.layout.fixed.vertical
                                },
                                expand = "none",
                                margins = dpi(8),
                                widget = wibox.container.margin
                            },
                            {
                                {
                                    volume_box,
                                    toggle_apps,
                                    playerctl,
                                    spacing = dpi(15),
                                    layout = wibox.layout.fixed.vertical
                                },
                                expand = "none",
                                margins = dpi(8),
                                widget = wibox.container.margin
                            },
                            layout = wibox.layout.align.horizontal
                        },
                        {
                            {
                                -- search_box,
                                halign = "center",
                                valign = "center",
                                widget = wibox.container.place
                            },
                            expand = "none",
                            margins = dpi(8),
                            widget = wibox.container.margin
                        },
                        layout = wibox.layout.align.vertical
                    },
                    margins = dpi(4),
                    widget = wibox.container.margin
                },
                shape = helpers.prrect(beautiful.widget_box_radius * 2, true, true, false, false),
                bg = beautiful.bg_normal,
                widget = wibox.container.background
            },
            layout = wibox.layout.align.vertical
        }
    }

    panel.opened = false

    awesome.connect_signal("dashboard::toggle", function(scr)
		if scr == s then
			s.dashboard.visible = not s.dashboard.visible
            awesome.emit_signal("date_dashboard::close", awful.screen.focused())
		end
	end)
    awesome.connect_signal("dashboard::close", function(scr)
		if scr == s then
            if s.dashboard.visible then
                s.dashboard.visible = not s.dashboard.visible
            end
		end
	end)

    return panel
end
return dashboard
