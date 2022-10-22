--  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
-- ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
-- ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
-- ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
-- ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝

-- =========================================================
-- ======================= IMPORTS =========================
-- =========================================================

-- Standard awesome library
local gears = require "gears"
local awful = require "awful"

-- Theme handling library
local beautiful = require "beautiful"

-- =========================================================
-- ================= USER CONFIGURATION ====================
-- =========================================================

-- color scheme
-- make sure
-- COLORS is at
-- line 27
COLORS = "gruvbox"

awful.spawn.with_shell(
	[[echo '@theme "rofi-]] .. COLORS .. [["' > ]] .. os.getenv "HOME" .. [[/.config/rofi/config.rasi]]
)
local rofi_command = "rofi -show drun"

-- Set lock theme
awful.spawn.with_shell(
	[[cat ~/.config/awesome/configs/lock-]]
		.. COLORS
		.. [[ > ]]
		.. gears.filesystem.get_configuration_dir()
		.. [[configs/lock]]
)

-- Default apps global variable
apps = {
	editor = "code",
	terminal = "kitty",
	launcher = rofi_command,
	lock = gears.filesystem.get_configuration_dir() .. "configs/lock-" .. COLORS,
	screenshot = "flameshot gui",
	filebrowser = "dolphin",
	browser = "microsoft-edge-stable",
	taskmanager = "gnome-system-monitor",
	soundctrlpanel = "pavucontrol",
}

-- define wireless and ethernet interface names for the network widget
-- use `ip link` command to determine these
-- NETWORK = {
--     wlan = "wlp1s0",
--     lan = "enp4s0"
-- }

--OpenWeatherMap
WEATHER = {
	key = "",
	city_id = "",
	units = "metric",
}

-- autostart startup apps
require "global.autostart"

-- svg icon color for each theme
ICON_COLORS = {
	nord = "#e5e9f0",
	gruvbox = "#EBDBB2",
	rxyhn = "#6791C9",
	everforest = "#ddd0b4",
	tokyonight = "#c0caf5"
}

-- -- changing gtk theme -----
-- make sure theme names are correct
THEME_NAMES = {
	nord = "Nordic",
	gruvbox = "Gruvbox",
	rxyhn = "Aesthetic-Night",
	everforest = "Everforest-Dark-BL",
	tokyonight = "Tokyo-Night",
}

--  changing kvantum theme ---
-- make sure theme names are correct
KV_THEME_NAMES = {
	nord = "Nordic",
	gruvbox = "gruvbox-kvantum",
	rxyhn = "Aesthetic-Night",
	everforest = "gruvbox-kvantum",
  tokyonight = "tokyo-night"
}

require "global.svg-color-changer"

-- -------- Layouts ----------
-- https://awesomewm.org/doc/api/libraries/awful.layout.html#Client_layouts

awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.floating,
	awful.layout.suit.max,
	awful.layout.suit.tile.bottom,
}

-- =========================================================
-- ======================== SETUP ==========================
-- =========================================================

-- ----- Import theme --------
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. COLORS .. ".lua")

-- ----- modules -------
require "global.bling"
require "submodules.better-resize"

-- ----- round corners -------
-- require("client.round-corners").enable()

-- ----- import panel --------
require "panels"

--- ------ Import Tags --------
require "panels.tags"

-- Titlebars on clients
-- require "client.titlebar"

-- - Import notifications ----
require "global.notification"

-- import menu
require "global.menu"

-- Import Keybinds
local keys = require "global.keys"
root.keys(keys.globalkeys)
root.buttons(keys.globalbuttons)

-- Import rules
local create_rules = require("client.rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- import widgets
require "widget.volume-slider.volume-osd"
require "widget.weather.weather_main"
require "widget.brightness-slider.brightness-osd"
require "global.exit-screen"

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the window as a slave (put it at the end of others instead of setting it as master)
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Make the focused window have a glowing border
client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_accent
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.bg_normal
end)

-- =========================================================
-- =================== CLIENT FOCUSING =====================
-- =========================================================

-- Autofocus a new client when previously focused one is closed
require "awful.autofocus"

-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

-- =========================================================
--  Garbage collection (allows for lower memory consumption) =
-- =========================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
