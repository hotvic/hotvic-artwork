-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/aurelio/.config/awesome/themes/hotvic/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "uxterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {
    screen = {
    {names = {"Web", "Ter", "Dev", "G", 5, 6, 7, "M", "IM"},
        layouts = {layouts[2], layouts[2], layouts[2], layouts[2], layouts[2],
                    layouts[2], layouts[2], layouts[2], layouts[2]}
    },
    {names = {"Mail", "Ter", "Dev", "Office", 5, 6, 7, "M"},
        layouts = {layouts[2], layouts[4], layouts[2], layouts[2], layouts[2],
        layouts[2],layouts[2],layouts[4]}
    }
}}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags.screen[s].names, s, tags.screen[s].layouts)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   {"Man Page", terminal .. " -e man awesome"},
   {"Edit lua.rc", editor_cmd .. " " .. awesome.conffile},
   {"Restart", awesome.restart},
   {"Quit", awesome.quit}
}

appsmenu = {
    {"Aurora",  "env MOZ_DISABLE_PANGO=1 aurora",   beautiful.aurora_icon},
    {"Carrier", "carrier",                          beautiful.carrier_icon},
    {"Chromium", "chromium --audio-buffer-size=2048 --purge-memory-button",  beautiful.chromium_icon},
    {"Exaile",  "exaile",                           beautiful.exaile_icon},
    {"GIMP",    "gimp",                             beautiful.gimp_icon}
}

mymainmenu = awful.menu({
    items = {
        {"Applications",    appsmenu,               beautiful.bookmakrs_icon},
        {"Awesome",         myawesomemenu,          beautiful.awesome_icon},
        {"Open XTerm",      terminal},
        {"Reboot",          "gksu systemctl reboot"},
        {"PowerOff",        "gksu systemctl poweroff"}
    }
})

mylauncher = awful.widget.launcher({image = beautiful.awesome_icon,
                                     menu = mymainmenu})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Separator widget
myseparator =  wibox.widget.textbox()
myseparator:set_markup([[<span style="normal" foreground="#FF0000"> | </span>]])

-- System monitor
--- Cpu usage
mycpuwidget = wibox.widget.textbox()
vicious.register(mycpuwidget, vicious.widgets.cpu, "$1%")

--- Memory
mymemwidget = wibox.widget.textbox()
vicious.register(mymemwidget, vicious.widgets.mem, "$2MB/$3MB", 5)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ },       1,  awful.tag.viewonly),
    awful.button({ modkey}, 1,  awful.client.movetotag),
    awful.button({ },       3,  awful.tag.viewtoggle),
    awful.button({ modkey },3,  awful.client.toggletag),
    awful.button({ },       4,  function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
    awful.button({ },       5,  function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({position = "top", screen = s})

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(mycpuwidget)
    right_layout:add(myseparator)
    right_layout:add(mymemwidget)
    right_layout:add(myseparator)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
--    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({modkey,},            "Left",     awful.tag.viewprev),
    awful.key({modkey,},            "Right",    awful.tag.viewnext),
    awful.key({modkey,},            "Escape",   awful.tag.history.restore),
    --
    awful.key({modkey,},            "j",        function ()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({modkey,},            "k",        function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({modkey,},            "w",        function () mymainmenu:show()               end),

    -- Layout manipulation
    awful.key({modkey, "Shift"},    "j",        function () awful.client.swap.byidx(  1)    end),
    awful.key({modkey, "Shift"},    "k",        function () awful.client.swap.byidx( -1)    end),
    awful.key({modkey, "Control"},  "j",        function () awful.screen.focus_relative( 1) end),
    awful.key({modkey, "Control"},  "k",        function () awful.screen.focus_relative(-1) end),
    awful.key({modkey,},            "u",        awful.client.urgent.jumpto),
    awful.key({modkey,},            "Tab",      function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end),

    -- Standard program
    awful.key({modkey,},            "Return",   function () awful.util.spawn(terminal)      end),
    awful.key({modkey, "Control"},  "r",        awesome.restart),
    awful.key({modkey, "Shift"},    "q",        awesome.quit),

    awful.key({modkey,},            "l",        function () awful.tag.incmwfact( 0.05)      end),
    awful.key({modkey,},            "h",        function () awful.tag.incmwfact(-0.05)      end),
    awful.key({modkey, "Shift"},    "h",        function () awful.tag.incnmaster( 1)        end),
    awful.key({modkey, "Shift"},    "l",        function () awful.tag.incnmaster(-1)        end),
    awful.key({modkey, "Control"},  "h",        function () awful.tag.incncol( 1)           end),
    awful.key({modkey, "Control"},  "l",        function () awful.tag.incncol(-1)           end),
    awful.key({modkey,},            "space",    function () awful.layout.inc(layouts,  1)   end),
    awful.key({modkey, "Shift"},    "space",    function () awful.layout.inc(layouts, -1)   end),

    awful.key({modkey, "Control"},  "n",        awful.client.restore),

    -- Prompt
    awful.key({modkey},             "r",        function () mypromptbox[mouse.screen]:run() end),

    awful.key({modkey},             "x",        function ()
        awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),
    -- Menubar
    awful.key({modkey},             "p",        function() menubar.show()                   end)
)

clientkeys = awful.util.table.join(
    awful.key({modkey,          },  "f",        function (c) c.fullscreen = not c.fullscreen end),
    awful.key({modkey, "Shift"  },  "c",        function (c) c:kill()                       end),
    awful.key({modkey, "Control"},  "space",    awful.client.floating.toggle),
    awful.key({modkey, "Control"},  "Return",   function (c) c:swap(awful.client.getmaster()) end),
    awful.key({modkey,          },  "o",        awful.client.movetoscreen),
    awful.key({modkey,          },  "t",        function (c) c.ontop = not c.ontop          end),
    awful.key({modkey,          },  "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({modkey,          },  "m", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    {rule = { },
        properties = {
            size_hints_honor = false,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            keys = clientkeys,
            buttons = clientbuttons
        },
    },
    {rule = {class = "MPlayer"},
        properties = {floating = true}
    },
    {rule = {class = "Eclipse"},
        properties = {tag = tags[1][3]}
    },
    {rule = {class = "Pavucontrol"},
        properties = {floating = true}
    },
    {rule = {class = "pinentry"},
        properties = {floating = true}
    },
    {rule = {class = "Gimp", role = "gimp-image-window"},
        properties = {
            tag = tags[1][4],
            floating = false,
            border_width = 0,
        }
    },
    {rule = {class = "Carrier", role = "buddy_list"},
        properties = {
            tag = tags[1][9],
            floating = true,
            maximized_vertical = true,
        },
        callback = function(c)
            local w_area = screen[c.screen].workarea
            local winwidth = 340
            c:struts({right = winwidth})
            c:geometry({x = w_area.width - winwidth, width = winwidth, y = w_area.y, height = w_area.height})
        end
    },
    {rule = {class = "Carrier", role = "conversation"},
        properties = {
            tag = tags[1][9],
            floating = false,
--            maximized_vertical = true,
--            maximized_horizontal = true
        }
    },
    {rule = {class = "manaplus"},
        properties = {
            maximized_vertical = true,
            maximized_horizontal = true,
            size_hints_honor = false,
            border_width = 0,
        }
    },
    {rule = {class = "Aurora", role = "browser"},
        properties = {
            tag = tags[1][1],
            border_width = 0,
        }
    },
    {rule = {class = "Aurora"}, except = {instance = "Navigator"},
        properties = {
            floating = true,
        }
    },
    {rule = {class = "Thunderbird", role = "3pane"},
        properties = {
            border_width = 0,
        }
    },
    {rule = {class = "Thunderbird", role = "Msgcompose"},
        properties = {
            floating = true,
        },
        callback = function (c)
            awful.placement.centered(c, nil)
        end
    },
    {rule = {class = "Wine"},
        properties = {
            screen = 2,
        }

    },
    {rule = {class = "Chromium", role = "browser"},
        properties = {
            border_width = 0,
            maximized_vertical = true,
            maximized_horizontal = true,
            size_hints_honor = false,
            floating = false,
        }
    },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- Remove borders of maximized windows
for s = 1, screen.count() do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
                                                                                                                                                            
    for _, c in pairs(clients) do
        if c.maximized_horizontal and c.maximized_vertical then
            c.border_width = 0 
        elseif #clients == 1 then
            c.border_width = 0 
        else
            c.border_width = beautiful.border_width
        end 
    end 
  end)
end
-- }}}
