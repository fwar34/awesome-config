-- ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
-- ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
--    ██║   ███████║█████╗  ██╔████╔██║█████╗
--    ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝
--    ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
--    ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝

-- =========================================================
-- ======================= Import ==========================
-- =========================================================

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("global.helpers")
local gears = require("gears")
local gfs = require("gears.filesystem")
local awful = require("awful")

-- define module table
local theme = {}

-- =========================================================
-- ======================= Pallete =========================
-- =========================================================

-- *---------------------------------------------------------------------------------------------
-- *  Homepage:   https://github.com/sainnhe/everforest-vscode
-- *  Copyright:  2020 Sainnhe Park <i@sainnhe.dev>
-- *  License:    MIT
-- *--------------------------------------------------------------------------------------------

--everforestb16
theme.bar = "#232a2f"
theme.grey = "#7f897d"

theme.base00 = "#2b3339"
theme.base01 = "#323c41"
theme.base02 = "#3a4248"
theme.base03 = "#424a50"
theme.base04 = "#4a5258"
theme.base05 = "#d3c6aa"
theme.base06 = "#ddd0b4"
theme.base07 = "#e7dabe"
theme.base08 = "#7fbbb3"
theme.base09 = "#d699b6"
theme.base0A = "#83c092"
theme.base0B = "#dbbc7f"
theme.base0C = "#e69875"
theme.base0D = "#a7c080"
theme.base0E = "#e67e80"
theme.base0F = "#d699b6"
theme.transparent = "#22000000"

-- =========================================================
-- =================== THEME VARIABLES =====================
-- =========================================================

-- ------- Wallpaper ---------
local directory = gfs.get_configuration_dir() .. "wallpapers/"
theme.wallpapers = {
    directory .. "forest.jpg", -- 1
    directory .. "forest1.jpg",
    directory .. "forest2.jpg",
    directory .. "forest3.jpg",
}
theme.wallpaper = theme.wallpapers[1]

theme.rofi_plus_sign = "everforest"

-- ---- profile picture ------
theme.pfp = gears.filesystem.get_configuration_dir() .. "icons/user/profile.png"

-- --------- wibar -----------
theme.wibar_height = dpi(36)

-- --------- gaps ------------
theme.useless_gap = dpi(12)
theme.gap_single_client = false

-- --------- Fonts -----------
theme.title_fonts = "Roboto Bold 11"
theme.normal_fonts = "Roboto 11"
theme.date_time_font = "Roboto Bold 11"
theme.icon_fonts = "JetBrainsMono Nerd Font"

-- -- clickable container ----
theme.mouse_enter = theme.grey
theme.mouse_press = theme.grey
theme.mouse_release = theme.base00

-- -------- accent -----------
theme.accent_normal = theme.base0D

-- -------- accent titlebar-----------
theme.accent_normal_c = theme.base0E
theme.accent_normal_max = theme.base0D
theme.accent_normal_min = theme.base0B
theme.accent_normal_float = theme.base08
theme.close_icon = ""
theme.maximize_icon = ""
theme.minimize_icon = ""
theme.float_icon = ""

-- ------ foreground ---------
theme.fg_normal = theme.base06
theme.fg_critical = theme.base07

-- ------ background ---------
theme.bg_normal = theme.bar
theme.bg_normal_alt = theme.base00
theme.bg_critical = theme.base0E

-- -------- client -----------
theme.titlebars_enabled = true
theme.titlebar_buttonsize_alt = dpi(16)
theme.titlebar_buttonsize = dpi(16)
theme.titlebar_size = dpi(25)
theme.titlebar_color = theme.bar
theme.border_width = dpi(1)
theme.border_accent = theme.grey
theme.corner_radius = dpi(8)

-- -------- widgets ----------
theme.widget_box_radius = dpi(12)
theme.widget_box_gap = dpi(8)
theme.widget_margin_color = theme.base01
theme.widget_bg_normal = theme.base00

-- ------- LayoutBox ---------
theme.layoutbox_width = dpi(24)

-- ------- dashboard ---------
theme.dashboard_min_height = dpi(600)
theme.dashboard_max_height = dpi(600)
theme.dashboard_max_width = dpi(600)
theme.dashboard_min_width = dpi(600)
theme.dashboard_margin = dpi(2)
theme.dashboard_margin_color = theme.base01

-- ------ System Tray --------
theme.systray_icon_spacing = dpi(8)

-- --------- Menu ------------
theme.menu_font = "Roboto 10"
theme.menu_height = dpi(24)
theme.menu_width = dpi(160)
theme.menu_border_color = theme.base01
theme.menu_border_width = dpi(2)
theme.menu_fg_focus = theme.accent_normal
theme.menu_bg_focus = theme.grey
theme.menu_fg_normal = theme.base06
theme.menu_bg_normal = theme.bg0

-- ------- TaskList ----------
theme.tasklist_font = "Roboto Mono Nerd Fonts Bold 10"
theme.tasklist_bg_normal = theme.base01
theme.tasklist_bg_focus = theme.base02
theme.tasklist_bg_urgent = theme.base0E
theme.tasklist_fg_focus = theme.base07
theme.tasklist_fg_urgent = theme.base07
theme.tasklist_fg_normal = theme.base06
-- theme.tasklist_disable_task_name = true
theme.tasklist_plain_task_name = true
theme.tasklist_shape = helpers.rect(dpi(4))

-- -------- Taglist ----------
theme.taglist_bg_empty    = theme.transparent
theme.taglist_bg_occupied = theme.transparent
theme.taglist_bg_urgent   = theme.transparent
theme.taglist_bg_focus    = theme.bar
theme.taglist_font        = theme.title_fonts
theme.taglist_fg_focus    = theme.base07
theme.taglist_fg_occupied = theme.base06
theme.taglist_fg_urgent   = theme.base0E
theme.taglist_fg_empty    = theme.base04
theme.taglist_bg_focus    = theme.base0D .. "aa"
theme.taglist_shape       = helpers.rrect(dpi(6))

-- --- tag preview bling -----
theme.tag_preview_widget_border_radius = dpi(0) -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = theme.border_width / 2 -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity = 1 -- Opacity of each client
theme.tag_preview_client_bg = theme.bar -- The bg color of each client
theme.tag_preview_client_border_color = theme.base02 -- The border color of each client
theme.tag_preview_client_border_width = dpi(1) -- The border width of each client
theme.tag_preview_widget_bg = theme.base01 -- The bg color of the widget
theme.tag_preview_widget_border_color = theme.base02 -- The border color of the widget
theme.tag_preview_widget_border_width = dpi(0) -- The border width of the widget
theme.tag_preview_widget_margin = dpi(0) -- The margin of the widget

-- ------- Snapping ----------
theme.snap_bg = theme.green
theme.snap_border_width = dpi(1)

-- ---- Toggle buttons -------
theme.toggle_button_inactive = theme.base01
theme.toggle_button_active = theme.base0D .. "60"

-- --------- music -----------
theme.music = gears.surface.load_uncached(gears.filesystem.get_configuration_dir() .. "wallpapers/music.png")
theme.playerctl_ignore = "firefox"
theme.playerctl_player = { "music", "%any" }

-- ------- date/time ---------
theme.date_time_color = theme.base0D
-- ------- calender ----------
theme.cal_header_bg = theme.transparent
theme.cal_week_bg = theme.transparent
theme.cal_focus_bg = theme.base01
theme.cal_header_fg = theme.base0D
theme.cal_focus_fg = theme.base07
theme.cal_week_fg = theme.base0D

-- ----- Hotkey popup --------
theme.hotkeys_shape = helpers.rrect(dpi(12))
theme.hotkeys_border_width = dpi(1)
theme.hotkeys_font = "JetBrainsMono Nerd Font 11"
theme.hotkeys_group_margin = dpi(10)
theme.hotkeys_label_bg = theme.base01
theme.hotkeys_label_fg = theme.bar
theme.hotkeys_description_font = "JetBrainsMono Nerd Font 8"
theme.hotkeys_modifiers_fg = theme.base06
theme.hotkeys_bg = theme.base00

-- --- flash focus bling -----
theme.flash_focus_start_opacity = 0.7 -- the starting opacity
theme.flash_focus_step = 0.01 -- the step of animation

-- --------- Icons -----------
local themes_path = "/usr/share/awesome/themes/"
local layouticons_path = gears.filesystem.get_configuration_dir() .. "icons/layout/"

theme.icon_color = theme.base0D

theme.awesome_icon = gears.color.recolor_image(themes_path .. "sky/awesome-icon.png", theme.icon_color)

-- layout icons
theme.layout_tile = gears.color.recolor_image(layouticons_path .. "tile.svg", theme.icon_color)
theme.layout_floating = gears.color.recolor_image(layouticons_path .. "float.svg", theme.icon_color)
theme.layout_max = gears.color.recolor_image(themes_path .. "default/layouts/fullscreenw.png", theme.icon_color)
-- theme.layout_dwindle = gears.color.recolor_image(themes_path .. "default/layouts/dwindlew.png", theme.icon_color)
theme.layout_tilebottom = gears.color.recolor_image(themes_path .. "default/layouts/tilebottom.png", theme.icon_color)

-- --------- extra -----------
-- theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
-- theme.layout_dwindle    = themes_path.."default/layouts/dwindlew.png"
-- theme.layout_cornernw   = themes_path.."default/layouts/cornernww.png"
-- theme.layout_cornerne   = themes_path.."default/layouts/cornernew.png"
-- theme.layout_cornersw   = themes_path.."default/layouts/cornersww.png"
-- theme.layout_cornerse   = themes_path.."default/layouts/cornersew.png"
-- theme.layout_tiletop    = themes_path.."default/layouts/tiletopw.png"
-- theme.layout_magnifier  = themes_path.."default/layouts/magnifierw.png"
-- theme.layout_max        = themes_path.."default/layouts/maxw.png"
-- theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
-- theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"

theme.icon_theme = "Papirus Dark"

-- return theme
return theme
