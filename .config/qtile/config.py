# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import EzClick as Click, EzDrag as Drag, Group, EzKey as Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os
os.system("sh ~/.config/qtile/autostart")
terminal = "alacritty"

keys = [
    # Switch between windows
    Key("M-h",  lazy.layout.left(), desc="Move focus to left"),
    Key("M-h", lazy.layout.left(), desc="Move focus to left"),
    Key("M-l", lazy.layout.right(), desc="Move focus to right"),
    Key("M-j", lazy.layout.down(), desc="Move focus down"),
    Key("M-k", lazy.layout.up(), desc="Move focus up"),
    Key("M-<space>", lazy.layout.next(), desc="Move window focus to other window"),
    Key("M-f", lazy.window.toggle_fullscreen()),
    Key("M-<period>", lazy.next_screen(), desc="Move focus to next screen"),
    Key("M-<comma>", lazy.prev_screen(), desc="Move focus tlasttt screen"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key("M-S-h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key("M-S-l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key("M-S-j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key("M-d", lazy.spawn("dmenu_run")),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key("M-C-h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key("M-C-l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key("M-C-j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key("M-C-k", lazy.layout.grow_up(), desc="Grow window up"),
    Key("M-n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key("M-<F11>", lazy.spawn("scrlock", shell=True), desc="Lock screen"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key("M-S-<Return>", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key("M-<Return>", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key("M-<Tab>", lazy.next_layout(), desc="Toggle between layouts"),
    Key("M-w", lazy.window.kill(), desc="Kill focused window"),

    Key("M-C-r", lazy.restart(), desc="Restart Qtile"),
    Key("M-C-q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key("M-r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key(f"M-{i.name}", lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key(f"M-S-{i.name}", lazy.window.togroup(i.name),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key("M-S, i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.Columns(border_focus_stack='#d75f5f',
        margin=8),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
    background="#282c34"
)
extension_defaults = widget_defaults.copy()
def widgetmain():
    widgets_global = [
            widget.GroupBox(
                hide_unused=True,
                highlight_method = "line",
                inactive = "#aaadab"
                ),
            widget.WindowName(),
            widget.Chord(
                chords_colors={
                    'launch': ("#ff0000", "#ffffff"),
                },
                name_transform=lambda name: name.upper(),

            ),
            widget.Systray(),
            widget.TextBox(
                text='\ue0be',
                foreground="#e06c75",
                fontsize='24',
                padding=0
                ),
            widget.CheckUpdates(
                background="#e06c75",
                padding = 0,
                distro = "Arch"
                ),

            widget.TextBox(
                text='\ue0be',
                foreground="#98c379",
                background="#e06c75",
                fontsize='24',
                padding=0
                ),
            widget.Clock(
                format="%A %B %d %Y",
                background="#98c379",
                ),


            widget.TextBox(
                text='\ue0be',
                foreground="#e5c07b",
                background="#98c379",
                fontsize='24',
                padding=0
                ),
            widget.CPU(
                background="#e5c07b",
                padding=0
                ),
            widget.TextBox(
                text='\ue0be',
                foreground='#c678dd',
                background="#e5c07b",
                fontsize='24',
                padding=0
                ),
            widget.Clock(
                format='%I:%M',
                background="#c678dd",
                padding=0
                ),
    ]
    return widgets_global
def widgetconf():
    widgets_list = widgetmain()
    return widgets_list

screens = [Screen(top=bar.Bar(widgetconf(), 24)),
           Screen(top=bar.Bar(widgetconf(), 24))]
    # Drag floating layouts.
mouse = [
        Drag("M-1", lazy.window.set_position_floating(),
             start=lazy.window.get_position()),
        Drag("M-3", lazy.window.set_size_floating(),
             start=lazy.window.get_size()),
        Click("M-2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
