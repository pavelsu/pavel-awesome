-- {{{ License
--
-- Awesome configuration, using awesome 3.4.3 on Arch GNU/Linux
--   * Adrian C. <anrxc@sysphere.org>

-- Screenshot: http://sysphere.org/gallery/snapshots

-- This work is licensed under the Creative Commons Attribution Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}

-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
-- User libraries
require("vicious")
require("teardrop")
require("scratchpad")
-- }}}

-- {{{ Variable definitions
--
-- Beautiful theme
beautiful.init(awful.util.getdir("config") .. "/zenburn.lua")

-- Modifier keys
altkey = "Mod1" -- Alt_L
modkey = "Mod4" -- Super_L

-- Function aliases
local exec  = awful.util.spawn
local sexec = awful.util.spawn_with_shell

-- Window management layouts
layouts = {
--  awful.layout.suit.spiral,
  awful.layout.suit.fair,
  awful.layout.suit.tile,        -- 1
  awful.layout.suit.tile.left,   -- 2
  awful.layout.suit.tile.bottom, -- 3
  awful.layout.suit.tile.top,    -- 4
  awful.layout.suit.max,         -- 5
  awful.layout.suit.magnifier,   -- 6
  awful.layout.suit.floating     -- 7
}
-- }}}


-- {{{ Tags
tags = {
  names  = { "*", "dev", "www", "media", "box", "chat", "todo", "8", "9" },
  layout = { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1],
             layouts[1], layouts[1], layouts[1], layouts[1] }
}

for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
    awful.tag.setproperty(tags[s][4], "mwfact", 0.1)
--    awful.tag.setproperty(tags[s][6], "hide",   true)
--    awful.tag.setproperty(tags[s][7], "hide",   true)
--    awful.tag.setproperty(tags[s][8], "hide",   true)
end
-- }}}

--- {{{ Menu
mymainmenu = awful.menu.new({ items = {
   { "&gvim", "gvim" },
--    { "&gvim", "gvim -S /home/pavel/.vim/vimrc/ide.vimrc" },
    { "&eclipse", "/home/pavel/.opt/eclipse/eclipse" },
    { "&netbeans", "/home/pavel/.config/awesome/netbeans" },
    { "&medit", "medit" },
    { "&thunar", "thunar" },
    { "&keepnote", "keepnote" },
    { "&firefox", "iceweasel" },
    { "&opera", "opera" },
    { "&chromium", "chromium" },
    { "&pidgin", "pidgin" },
    { "&xchat", "xchat" },
    { "gimp", "gimp" },
    { "&virtualbox", "VirtualBox" },
    { "&audacious", "audacious" },
    { "vlc", "vlc" },
    { "reboot", "/home/pavel/.config/awesome/reboot" },
    { "shutdonw", "/home/pavel/.config/awesome/shutdown" }
---    { "&", "" },
}})
--- }}}


-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separators
spacer    = widget({ type = "textbox"  })
separator = widget({ type = "imagebox" })
spacer.text     = " "
separator.image = image(beautiful.widget_sep)
-- }}}

-- {{{ CPU usage and temperature
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)
-- Initialize widgets
cpugraph  = awful.widget.graph()
tzswidget = widget({ type = "textbox" })
-- Graph properties
cpugraph:set_width(50)
cpugraph:set_height(14)
cpugraph:set_background_color(beautiful.fg_off_widget)
cpugraph:set_color(beautiful.fg_end_widget)
cpugraph:set_gradient_angle(0)
cpugraph:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_widget
}) -- Register widgets
vicious.register(cpugraph,  vicious.widgets.cpu,     "$1")
-- vicious.register(tzswidget, vicious.widgets.thermal, "$1C", 19, "thermal_zone0")
-- }}}

-- {{{ Battery state
baticon = widget({ type = "imagebox" })
baticon.image = image(beautiful.widget_bat)
-- Initialize widget
batwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(batwidget, vicious.widgets.bat, "$1$2%", 61, "BAT0")
-- }}}

-- {{{ Memory usage
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)
-- Initialize widget
membar = awful.widget.progressbar()
-- Pogressbar properties
membar:set_width(10)
membar:set_height(12)
membar:set_vertical(true)
membar:set_background_color(beautiful.fg_off_widget)
membar:set_border_color(beautiful.border_widget)
membar:set_color(beautiful.fg_widget)
membar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Register widget
vicious.register(membar, vicious.widgets.mem, "$1", 13)
-- }}}

-- {{{ File system usage
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)
-- Initialize widgets
fs = {
  r = awful.widget.progressbar(),  h = awful.widget.progressbar(),
  s = awful.widget.progressbar(),  b = awful.widget.progressbar()
}
-- Progressbar properties
for _, w in pairs(fs) do
  w:set_width(5)
  w:set_height(12)
  w:set_vertical(true)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_border_color(beautiful.border_widget)
  w:set_color(beautiful.fg_widget)
  w:set_gradient_colors({ beautiful.fg_widget,
     beautiful.fg_center_widget, beautiful.fg_end_widget
  }) -- Register buttons
  w.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("rox", false) end)
  ))
end
-- Register widgets
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",            599)
vicious.register(fs.h, vicious.widgets.fs, "${/home used_p}",        599)
-- vicious.register(fs.s, vicious.widgets.fs, "${/data used_p}",    599)
-- }}}

-- {{{ Date and time
dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, "%b %d, %R", 61)
-- Register buttons
datewidget:buttons(awful.util.table.join(
  awful.button({ }, 1, function () exec("pylendar.py") end)
))
-- }}}

-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
-- Progressbar properties
volbar:set_width(10)
volbar:set_height(12)
volbar:set_vertical(true)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_border_color(beautiful.border_widget)
volbar:set_color(beautiful.fg_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
})
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume, "$1",  0.1, "Master")
-- Register buttons
volbar.widget:buttons(awful.util.table.join(
--   awful.button({ }, 1, function () sexec("urxvt -e alsamixer") end),
   awful.button({ }, 1, function () sexec("amixer -q sset Master toggle")   end),
   awful.button({ }, 4, function () sexec("amixer -q sset Master 2dB+", false) end),
   awful.button({ }, 5, function () sexec("amixer -q sset Master 2dB-", false) end)
))
-- }}}

-- {{{ Key layout widget
kbdwidget = widget({type = "textbox", name = "kbdwidget"})
kbdwidget.border_width = 0
kbdwidget.border_color = beautiful.fg_normal
kbdwidget.text = " En "

dbus.request_name("session", "ru.gentoo.kbdd")
dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
dbus.add_signal("ru.gentoo.kbdd", function(...)
    local data = {...}
    local layout = data[2]
    lts = {[0] = "En", [1] = "Ру"}
    kbdwidget.text = " "..lts[layout].." "
    end
)
-- }}}


-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- {{{ Wibox initialisation
wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev
))

for s = 1, screen.count() do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts, 1)  end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts, 1)  end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)
    -- Create the wibox
    wibox[s] = awful.wibox({      screen = s,
        fg = beautiful.fg_normal, height = 12,
        bg = beautiful.bg_normal, position = "bottom",
        border_color = beautiful.border_focus,
        border_width = 0, --beautiful.border_width
    })
    -- Add widgets to the wibox
    wibox[s].widgets = {
        {   taglist[s], layoutbox[s], separator, promptbox[s],
            ["layout"] = awful.widget.layout.horizontal.leftright
        },
        datewidget, dateicon,
        separator, kbdwidget,
        separator, volbar.widget, volicon,
        -- separator, batwidget, baticon,
        separator, fs.s.widget, fs.h.widget, fs.r.widget, fsicon,
        separator, cpugraph.widget, cpuicon,
        separator, membar.widget, memicon,
        separator, s == screen.count() and systray or nil,
        ["layout"] = awful.widget.layout.horizontal.rightleft
    }
    -- wibox[s].visible = false

end
-- }}}
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}


-- {{{ Key bindings
--
-- {{{ Global keys
globalkeys = awful.util.table.join(
    --- {{{ Menu
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),
    --- }}}

    -- {{{ Applications
    awful.key({ modkey , "Shift" }, "Insert", function ()
        sexec("xterm -fn -xos4-terminus-medium-r-*-*-14-*-*-*-*-*-iso10646-1") end),
    awful.key({ modkey }, "t", function () sexec("rox-filer") end),
    --- awful.key({ }, "Print", function () exec("scrot /tmp/screen.png &") end),
    --- awful.key({ "Alt" }, "Print", function () exec("scrot -u /tmp/screen.png ") end),
    -- }}}

    -- {{{ Multimedia keys
    awful.key({ modkey }, "=", function () sexec("amixer -q -c 0 sset PCM,0 10%+") end),
    awful.key({ modkey }, "-", function () sexec("amixer -q -c 0 sset PCM,0 10%-") end),
    awful.key({ modkey }, "0", function () sexec("~/.config/awesome/sound-sitch") end),
    -- }}}

    -- {{{ Consoleap
    awful.key({ modkey }, "r", function ()
        awful.prompt.run({ prompt = "Run: " }, promptbox[mouse.screen].widget,
            function (...) promptbox[mouse.screen].text = exec(unpack(arg), false) end,
            awful.completion.shell, awful.util.getdir("cache") .. "/history")
    end),
    -- }}}

    -- {{{ Awesome controls
    awful.key({ modkey }, "b", function ()
        wibox[mouse.screen].visible = not wibox[mouse.screen].visible
    end),
    -- awful.key({ modkey, "Shift" }, "q", awesome.quit),
    awful.key({ modkey, "Shift" }, "r", function ()
        promptbox[mouse.screen].text = awful.util.escape(awful.util.restart())
    end),
    -- }}}

    -- {{{ Tag browsing
    -- awful.key({ altkey }, "n",   awful.tag.viewnext),
    -- awful.key({ altkey }, "p",   awful.tag.viewprev),
    awful.key({ altkey }, "Tab", awful.tag.history.restore),
    -- }}}

    -- {{{ Layout manipulation
    awful.key({ modkey }, "l",          function () awful.tag.incmwfact(0.05) end),
    awful.key({ modkey }, "h",          function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.incwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "h", function () awful.client.incwfact(0.05) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey },          "space", function () awful.layout.inc(layouts, 1) end),
    -- }}}

    -- {{{ Focus controls
    awful.key({ modkey }, "p", function () awful.screen.focus_relative(1) end),
    awful.key({ modkey }, "s", function () scratchpad.toggle() end),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey }, "Left", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "Right", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "Up", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "Down", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "j", function ()
        awful.client.focus.byidx(1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k", function ()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "Tab", function ()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    awful.key({ altkey }, "Escape", function () mouse.coords({x=525, y=330}, true)
        awful.menu.menu_keys.down = { "Down", "Alt_L" }
        local cmenu = awful.menu.clients({ width = 400 }, true)
    end),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx(1) end),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end)
    -- }}}
)
-- }}}

-- {{{ Client manipulation
clientkeys = awful.util.table.join(
    awful.key({ modkey }, "c", function (c) c:kill() end),
    awful.key({ modkey }, "d", function (c) scratchpad.set(c, 0.60, 0.60, true) end),
    awful.key({ modkey }, "f", function (c)
        awful.titlebar.remove(c)
        c.fullscreen           = not c.fullscreen
    end),
    awful.key({ modkey }, "m", function (c)
        c.maximized_horizontal = not c.maximized_horizontal
        c.maximized_vertical   = not c.maximized_vertical
    end),
    awful.key({ modkey }, "o",     awful.client.movetoscreen),
    awful.key({ modkey }, "Next",  function () awful.client.moveresize(20, 20, -40, -40) end),
    awful.key({ modkey }, "Prior", function () awful.client.moveresize(-20, -20, 40, 40) end),
    --awful.key({ modkey }, "Down",  function () awful.client.moveresize(0, 20, 0, 0) end),
    --awful.key({ modkey }, "Up",    function () awful.client.moveresize(0, -20, 0, 0) end),
    --awful.key({ modkey }, "Left",  function () awful.client.moveresize(-20, 0, 0, 0) end),
    --awful.key({ modkey }, "Right", function () awful.client.moveresize(20, 0, 0, 0) end),
    awful.key({ modkey, "Control"},"r", function (c) c:redraw() end),
    awful.key({ modkey, "Shift" }, "0", function (c) c.sticky = not c.sticky end),
    awful.key({ modkey, "Shift" }, "m", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Shift" }, "c", function (c) exec("kill -CONT " .. c.pid) end),
    awful.key({ modkey, "Shift" }, "s", function (c) exec("kill -STOP " .. c.pid) end),
    awful.key({ modkey, "Shift" }, "t", function (c)
        if   c.titlebar then awful.titlebar.remove(c)
        else awful.titlebar.add(c, { modkey = modkey }) end
    end),
    awful.key({ modkey, "Shift" }, "f", function (c) if awful.client.floating.get(c)
        then awful.client.floating.delete(c);    awful.titlebar.remove(c)
        else awful.client.floating.set(c, true); awful.titlebar.add(c) end
    end)
)
-- }}}

-- {{{ Keyboard digits
local keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end
-- }}}

-- {{{ Tag controls
for i = 1, keynumber do
    globalkeys = awful.util.table.join( globalkeys,
        awful.key({ modkey }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewonly(tags[screen][i]) end
        end),
        awful.key({ modkey, "Control" }, "#" .. i + 9, function ()
            local screen = mouse.screen
            if tags[screen][i] then awful.tag.viewtoggle(tags[screen][i]) end
        end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.movetotag(tags[client.focus.screen][i])
            end
        end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function ()
            if client.focus and tags[client.focus.screen][i] then
                awful.client.toggletag(tags[client.focus.screen][i])
            end
        end))
end
-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
    { rule = { }, properties = {
      focus = true,      size_hints_honor = false,
      keys = clientkeys, buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal }
    },
    { rule = { name = "tilda" },
      properties = { floating = true,
      border_width = 0 },
      callback = awful.titlebar.remove },
    { rule = { name = "medit" },
      properties = { floating = true } },
 --   { rule = { name = "VLC" },
 --     properties = { floating = true } },
    { rule = { name = "GoldenDict" },
      properties = { floating = true },
      callback = awful.titlebar.remove },
    { rule = { name = "urxvt" },
    --- properties = { floating = true },
      callback = awful.titlebar.remove },
    { rule = { name = "pavel@debian" },
      properties = { floating = true },
      callback = awful.titlebar.remove },
    -- dev
    { rule = { name = "Eclipse" },
      properties = { tag = tags[1][2] } },
    { rule = { name = "Aptana" },
      properties = { tag = tags[1][2] } },
    -- www
    { rule = { name = "Opera" },
      properties = { floating = false  } },
    --{ rule = { name = "Chromium" },
    --  properties = { tag = tags[1][3] } },
    --{ rule = { name = "Iceweasel" },
    --  properties = { tag = tags[1][3] } },
    -- media
    { rule = { name = "Audacious" },
      properties = { tag = tags[1][4] } },
    -- box
    { rule = { name = "VirtualBox" },
      properties = { tag = tags[1][5] } },
    { rule = { name = "QEMU" },
      properties = { tag = tags[1][5] }},
    -- Chat
    { rule = { name = "Pidgin" },
      properties = { tag = tags[1][6] } },
    { rule = { name = "Список собеседников" },
      properties = { tag = tags[1][6] } },
    { rule = { name = "X-Chat" },
      properties = { tag = tags[1][6] } },
    -- Todo
    { rule = { name = "keepnote" },
      properties = { tag = tags[1][7] } },
    { rule = { name = "Учёт времени" },
      properties = { tag = tags[1][7] } },


    { rule = { class = "Gajim.py" },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Akregator" },
      properties = { tag = tags[1][8] } },
--- { rule = { class = "macs", instance = "emacs" },
---   properties = { tag = tags[screen.count()][2] } },
--- { rule = { class = "Emacs", instance = "_Remember_" },
---      properties = { floating = true },
---      callback = awful.titlebar.add  },
    { rule = { class = "Xmessage", instance = "xmessage" },
      properties = { floating = true },
      callback = awful.titlebar.add  },
    { rule = { class = "ROX-Filer" },
      properties = { floating = true } },
    { rule = { class = "Tilda" },
      properties = { floating = true },
      callback = awful.titlebar.remove },
    { rule = { class = "Ark" },
      properties = { floating = true } },
    { rule = { class = "Geeqie" },
      properties = { floating = true } },
    { rule = { class = "Pinentry.*" },
      properties = { floating = true } },
}
-- }}}


-- {{{ Signals
--
-- {{{ Manage signal handler
client.add_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    if awful.client.floating.get(c)
    or awful.layout.get(c.screen) == awful.layout.suit.floating then
        if   c.titlebar then awful.titlebar.remove(c)
        else awful.titlebar.add(c, {modkey = modkey}) end
    end

    -- Enable sloppy focus
--  c:add_signal("mouse::enter", function (c)
--      if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--      and awful.client.focus.filter(c) then
--          client.focus = c
--      end
--  end)

    -- Client placement
    if not startup then
        awful.client.setslave(c)

        if  not c.size_hints.program_position
        and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

-- {{{ Focus signal handlers
client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
-- }}}
-- }}}
