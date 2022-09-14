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
local gears = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

local helpers = require("global.helpers")

-- =========================================================
-- ================= USER CONFIGURATION ====================
-- =========================================================

-- color scheme
-- make sure COLORS is at line 27
COLORS = "rxyhn"

--Rofi Launcher
awful.spawn.with_shell([[echo '@theme "rofi-]] ..
    COLORS .. [["' > ]] .. os.getenv("HOME") .. [[/.config/rofi/config.rasi]])
local rofi_command = "rofi -show drun"

-- Set lock theme
awful.spawn.with_shell([[cat ~/.config/awesome/configs/lock-]] ..
    COLORS .. [[ > ]] .. gears.filesystem.get_configuration_dir() .. [[configs/lock]])

-- Default apps global variable
apps = {
    editor = "code",
    terminal = "alacritty",
    launcher = rofi_command,
    lock = gears.filesystem.get_configuration_dir() .. "configs/lock-" .. COLORS,
    screenshot = "flameshot gui",
    filebrowser = "dolphin",
    browser = "firefox",
    taskmanager = "gnome-system-monitor",
    soundctrlpanel = "pavucontrol"
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
    units = "metric"
}

-- Startup apps
--- picom
helpers.check_if_running(
    "picom",
    nil,
    function()
        awful.spawn("picom --experimental-backends --config " ..
            gears.filesystem.get_configuration_dir() .. "configs/picom.conf", false)
    end
)
helpers.run_once_pgrep("mpd")
helpers.run_once_pgrep("mpDris2")
--- Polkit Agent
helpers.run_once_ps(
    "polkit-gnome-authentication-agent-1",
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
)
--- Other stuff
helpers.run_once_pgrep("blueman-applet")
helpers.run_once_pgrep("nm-applet --indicator")
helpers.run_once_pgrep(gears.filesystem.get_configuration_dir() .. "configs/nvidia-startup")
-- this will turn screen off when i3lock starts with xidlehook
awful.spawn.with_shell([[echo "& sleep 5 && xset dpms force off" >> ]] ..
    gears.filesystem.get_configuration_dir() .. [[configs/lock]])
helpers.check_if_running(
    "xidlehook",
    nil,
    function()
        helpers.run_once_pgrep(gears.filesystem.get_configuration_dir() .. "configs/xidlehook")
    end
)

-- Scripts
local cache_dir = os.getenv("HOME") .. "/.cache/awesome/"

local icon_colors = {
    nord = "#e5e9f0",
    gruvbox = "#EBDBB2",
    rxyhn = "#6791C9",
    everforest = "#ddd0b4"
}

-- check if prev cache exists if not create one
awful.spawn.easy_async_with_shell(
    [[
        test -f ]] .. cache_dir .. [[prev_theme && echo "yes"
    ]],
    function(stdout)
        if stdout:match("yes") then
            awful.spawn.with_shell('echo "xax"')
        else
            awful.spawn.with_shell('echo "rxyhn" > ' .. cache_dir .. 'prev_theme')
        end
    end
)

-- Changin color of Svg icons
local icon_location1 = os.getenv("HOME") .. "/.config/awesome/icons/flaticons/"
local icon_location2 = os.getenv("HOME") .. "/.config/awesome/icons/places/"
local prev_theme = helpers.first_line(cache_dir .. "prev_theme")

local function changeColor(prev, new)
    awful.spawn.easy_async_with_shell([[
                    for x in ]] .. icon_location1 .. [[*
                    do
                    sed -i "s/]] .. prev .. [[/]] .. new .. [[/g" $x
                    done
                ]])
    awful.spawn.easy_async_with_shell([[
                    for x in ]] .. icon_location2 .. [[*
                    do
                    sed -i "s/]] .. prev .. [[/]] .. new .. [[/g" $x
                    done
                ]])
end

changeColor(icon_colors[prev_theme], icon_colors[COLORS])

--  changing alacritty theme --
local alacrittycfg = os.getenv("HOME") .. "/.config/alacritty/alacritty.yml"
awful.spawn.with_shell([[
    sed -i 's/*]] .. prev_theme .. [[/*]] .. COLORS .. [[/' ]] .. alacrittycfg .. [[
]])

-- -- changing gtk theme -----
-- make sure theme names are correct
local theme_names = {
    nord = "Nordic",
    gruvbox = "Gruvbox",
    rxyhn = "Aesthetic-Night",
    everforest = "Everforest-Dark-BL"
}
local gtk_cfg = os.getenv("HOME") .. "/.config/gtk-3.0/settings.ini"
awful.spawn.with_shell([[
    sed -i 's/]] .. theme_names[prev_theme] .. [[/]] .. theme_names[COLORS] .. [[/' ]] .. gtk_cfg .. [[
]])

--  changing kvantum theme ---
local kv_theme_names = {
    nord = "Nordic",
    gruvbox = "gruvbox-kvantum",
    rxyhn = "Aesthetic-Night",
    everforest = "gruvbox-kvantum"
}
local kvantumcfg = os.getenv("HOME") .. "/.config/Kvantum/kvantum.kvconfig"
awful.spawn.with_shell([[
    echo "[General]
    theme=]] .. kv_theme_names[COLORS] .. [[" > ]] .. kvantumcfg .. [[
]])

-- =========================================================
-- =================== DEFINE LAYOUTS ======================
-- =========================================================

-- https://awesomewm.org/doc/api/libraries/awful.layout.html#Client_layouts
-- set icons in the theme file

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    awful.layout.suit.spiral.dwindle,
}

-- =========================================================
-- ======================== SETUP ==========================
-- =========================================================

-- ----- Import theme --------
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/" .. COLORS .. ".lua")

-- ----- modules -------
require("global.bling")
require("submodules.better-resize")

-- ----- round corners -------
-- require("client.round-corners").enable()

-- ----- import panel --------
require("panels")

--- ------ Import Tags --------
require("panels.tags")

-- Titlebars on clients
require("client.titlebar")

-- - Import notifications ----
require("global.notification")

-- import menu
require("global.menu")

-- Import Keybinds
local keys = require("global.keys")
root.keys(keys.globalkeys)
root.buttons(keys.globalbuttons)

-- Import rules
local create_rules = require("client.rules").create
awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

-- import widgets
require("widget.volume-slider.volume-osd")
require("widget.weather.weather_main")
require("widget.brightness-slider.brightness-osd")
require("global.exit-screen")

-- Signal function to execute when a new client appears.
client.connect_signal(
    "manage",
    function(c)
        -- Set the window as a slave (put it at the end of others instead of setting it as master)
        if not awesome.startup then
            awful.client.setslave(c)
        end

        if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
            -- Prevent clients from being unreachable after screen count changes.
            awful.placement.no_offscreen(c)
        end
    end
)

-- Make the focused window have a glowing border
client.connect_signal(
    "focus",
    function(c)
        c.border_color = beautiful.border_accent
    end
)
client.connect_signal(
    "unfocus",
    function(c)
        c.border_color = beautiful.bg_normal
    end
)

-- =========================================================
-- =================== CLIENT FOCUSING =====================
-- =========================================================

-- Autofocus a new client when previously focused one is closed
require("awful.autofocus")

-- Focus clients under mouse
client.connect_signal(
    "mouse::enter",
    function(c)
        c:emit_signal("request::activate", "mouse_enter", { raise = false })
    end
)

-- =========================================================
--  Garbage collection (allows for lower memory consumption) =
-- =========================================================

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
