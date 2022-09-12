local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")

-- --------- menu ------------

local myawesomemenu = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end
    },
    {
        "manual",
        apps.terminal .. " -e man awesome"
    },
    {
        "edit config",
        apps.editor .. " " .. awesome.conffile
    },
    {
        "restart",
        awesome.restart
    },
    {
        "quit",
        function()
            awesome.quit()
        end
    },
}

local awesomecfg = os.getenv("HOME") .. "/.config/awesome/rc.lua"
local theme_menu = {
    {
        "nord",
        function()
            awful.spawn.with_shell([[
                sed -i 's/gruvbox/nord/g;s/rxyhn/nord/g' ]] .. awesomecfg .. [[;
                echo 'awesome.restart()' | awesome-client
            ]])
        end
    },
    {
        "gruvbox",
        function()
            awful.spawn.with_shell([[
                sed -i 's/nord/gruvbox/g;s/rxyhn/gruvbox/g' ]] .. awesomecfg .. [[;
                echo 'awesome.restart()' | awesome-client
            ]])
        end
    },
    {
        "ryxhn",
        function()
            awful.spawn.with_shell([[
                sed -i 's/gruvbox/rxyhn/g;s/nord/rxyhn/g' ]] .. awesomecfg .. [[;
                echo 'awesome.restart()' | awesome-client
            ]])
        end
    },
}

local run_menu = {
    {
        "Terminal",
        apps.terminal
    },
    {
        "Browser",
        apps.browser
    },
    {
        "Text Editor",
        apps.editor
    },
    {
        "File Manager",
        apps.filebrowser
    },
}

local main_menu = awful.menu({
    items = {
        {
            "Refresh", awesome.restart
        },
        {
            "Run", run_menu
        },
        {
            "Theme", theme_menu
        },
        {
            "Awesome", myawesomemenu, beautiful.awesome_icon
        },
    }
})

awesome.connect_signal("menu::toggle", function()
    main_menu:toggle()
end)

awesome.connect_signal("menu::hide", function()
    main_menu:hide()
end)
