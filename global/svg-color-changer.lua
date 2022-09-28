local helpers = require("global.helpers")
local gears = require("gears")
local awful = require("awful")

-- Scripts
local cache_dir = os.getenv("HOME") .. "/.cache/awesome/"

-- check if prev cache exists if not create one
awful.spawn.easy_async_with_shell(
    [[
        test -f ]] .. cache_dir .. [[prev_theme && echo "yes"
    ]],
    function(stdout)
        if stdout:match("yes") then
            awful.spawn.with_shell('echo " "')
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

changeColor(ICON_COLORS[prev_theme], ICON_COLORS[COLORS])

--  changing alacritty theme --
local alacrittycfg = os.getenv("HOME") .. "/.config/alacritty/alacritty.yml"
awful.spawn.with_shell([[
    sed -i 's/*]] .. prev_theme .. [[/*]] .. COLORS .. [[/' ]] .. alacrittycfg .. [[
]])

-- -- changing gtk theme -----
local gtk_cfg = os.getenv("HOME") .. "/.config/gtk-3.0/settings.ini"
awful.spawn.with_shell([[
    sed -i 's/]] .. THEME_NAMES[prev_theme] .. [[/]] .. THEME_NAMES[COLORS] .. [[/' ]] .. gtk_cfg .. [[
]])

--  changing kvantum theme ---
local kvantumcfg = os.getenv("HOME") .. "/.config/Kvantum/kvantum.kvconfig"
awful.spawn.with_shell([[
    echo "[General]
    theme=]] .. KV_THEME_NAMES[COLORS] .. [[" > ]] .. kvantumcfg .. [[
]])
