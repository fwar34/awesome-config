--      ████████╗ █████╗  ██████╗     ██╗     ██╗███████╗████████╗
--      ╚══██╔══╝██╔══██╗██╔════╝     ██║     ██║██╔════╝╚══██╔══╝
--         ██║   ███████║██║  ███╗    ██║     ██║███████╗   ██║
--         ██║   ██╔══██║██║   ██║    ██║     ██║╚════██║   ██║
--         ██║   ██║  ██║╚██████╔╝    ███████╗██║███████║   ██║
--         ╚═╝   ╚═╝  ╚═╝ ╚═════╝     ╚══════╝╚═╝╚══════╝   ╚═╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local helpers = require("global.helpers")

-- ===================================================================
-- Widget Creation Functions
-- ===================================================================

-- default modkey
local modkey = "Mod4"

local taglist_buttons =
gears.table.join(
  awful.button(
    {},
    1,
    function(t)
      t:view_only()
    end
  ),
  awful.button(
    { modkey },
    1,
    function(t)
      if client.focus then
        client.focus:move_to_tag(t)
      end
    end
  ),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button(
    { modkey },
    3,
    function(t)
      if client.focus then
        client.focus:toggle_tag(t)
      end
    end
  ),
  awful.button(
    {},
    4,
    function(t)
      awful.tag.viewnext(t.screen)
    end
  ),
  awful.button(
    {},
    5,
    function(t)
      awful.tag.viewprev(t.screen)
    end
  )
)

local TagList = function(s)
  local tag_list =
  awful.widget.taglist {
    screen          = s,
    filter          = awful.widget.taglist.filter.all,
    layout          = {
      spacing        = dpi(10),
      spacing_widget = {
        color  = beautiful.transparent,
        shape  = function(cr)
          gears.shape.rounded_rect(cr, dpi(6), dpi(32), dpi(0))
        end,
        widget = wibox.widget.separator,
      },
      layout         = wibox.layout.fixed.horizontal
    },
    widget_template = {
      {
        {
          {
            id = "text_role",
            widget = wibox.widget.textbox,
            markup = "DD",
            align = "center",
            valign = "center"
          },
          margins = dpi(6),
          widget  = wibox.container.margin,
        },
        widget = wibox.container.background
      },
      id = "background_role",
      bg = beautiful.accent_normal,
      widget = wibox.container.background,
      create_callback = function(self, c3, _)
        -- Tag Preview
        self:connect_signal(
          "mouse::enter",
          function()
            if #c3:clients() > 0 then
              awesome.emit_signal("bling::tag_preview::update", c3)
              awesome.emit_signal("bling::tag_preview::visibility", s, true)
            end
          end
        )

        self:connect_signal(
          "mouse::leave",
          function()
            awesome.emit_signal("bling::tag_preview::visibility", s, false)
          end
        )
      end,
      update_callback = function(self, c3, _)
        if c3.selected then
          self:get_children_by_id("background_role")[1].bg = beautiful.bg_normal
        elseif #c3:clients() == 0 then
          self:get_children_by_id("background_role")[1].bg = beautiful.fg_normal
        else
          self:get_children_by_id("background_role")[1].bg = beautiful.fg_critical
        end
      end
    },
    buttons = taglist_buttons
  }

  local tag_list_container = wibox.widget {
    {
      tag_list,
      layout = wibox.layout.fixed.horizontal,
    },
    shape = helpers.rrect(dpi(6)),
    bg = beautiful.widget_bg_normal,
    widget = wibox.container.background,
  }
  local tlc = wibox.container.margin(tag_list_container, dpi(0), dpi(0), dpi(2), dpi(2))

  return tlc
end

return TagList
