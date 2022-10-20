local awful = require "awful"
local hotkeys_popup = require "awful.hotkeys_popup"
local beautiful = require "beautiful"
local cache_dir = os.getenv "HOME" .. "/.cache/awesome/"

-- --------- menu ------------

local myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{
		"manual",
		apps.terminal .. " -e man awesome",
	},
	{
		"edit config",
		apps.editor .. " " .. awesome.conffile,
	},
	{
		"restart",
		awesome.restart,
	},
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local awesomecfg = os.getenv "HOME" .. "/.config/awesome/rc.lua"
local theme_menu = {
	{
		"nord",
		function()
			awful.spawn.with_shell([[
                echo "]] .. COLORS .. [[" > ]] .. cache_dir .. [['prev_theme'
                sed -i '27s/.*/COLORS = "nord"/' ]] .. awesomecfg .. [[;
                echo 'awesome.restart()' | awesome-client
            ]])
		end,
	},
	{
		"gruvbox",
		function()
			awful.spawn.with_shell([[
                echo "]] .. COLORS .. [[" > ]] .. cache_dir .. [['prev_theme'
                sed -i '27s/.*/COLORS = "gruvbox"/' ]] .. awesomecfg .. [[;
                echo 'awesome.restart()' | awesome-client
            ]])
		end,
	},
	{
		"rxyhn",
		function()
			awful.spawn.with_shell([[
                echo "]] .. COLORS .. [[" > ]] .. cache_dir .. [['prev_theme'
                sed -i '27s/.*/COLORS = "rxyhn"/' ]] .. awesomecfg .. [[;
                echo 'awesome.restart()' | awesome-client
            ]])
		end,
	},
	{
		"everforest",
		function()
			awful.spawn.with_shell([[
                echo "]] .. COLORS .. [[" > ]] .. cache_dir .. [['prev_theme'
                sed -i '27s/.*/COLORS = "everforest"/' ]] .. awesomecfg .. [[;
                echo 'awesome.restart()' | awesome-client
            ]])
		end,
	},
	{
		"tokyonight",
		function()
			awful.spawn.with_shell([[
                echo "]] .. COLORS .. [[" > ]] .. cache_dir .. [['prev_theme'
                sed -i '27s/.*/COLORS = "tokyonight"/' ]] .. awesomecfg .. [[;
                echo 'awesome.restart()' | awesome-client
            ]])
		end,
	},
} -- change value of prev theme to current value
awful.spawn.with_shell('sleep 1; echo "' .. COLORS .. '" > ' .. cache_dir .. "prev_theme")

local run_menu = {
	{
		"Terminal",
		apps.terminal,
	},
	{
		"Browser",
		apps.browser,
	},
	{
		"Text Editor",
		apps.editor,
	},
	{
		"File Manager",
		apps.filebrowser,
	},
}

local main_menu = awful.menu {
	items = {
		{
			"Refresh",
			awesome.restart,
		},
		{
			"Run",
			run_menu,
		},
		{
			"Theme",
			theme_menu,
		},
		{
			"Awesome",
			myawesomemenu,
			beautiful.awesome_icon,
		},
	},
}

awesome.connect_signal("menu::toggle", function()
	main_menu:toggle()
end)

awesome.connect_signal("menu::hide", function()
	main_menu:hide()
end)
