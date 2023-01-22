#!/bin/sh

# xfconf-query: access config data stored in xfconf.
#
# Restart panel to see the changes:
#   xfce4-panel -r
#
# Start monitoring channel to see changes in text:
#   xfconf-query -c xfce4-panel -m
#
# Reset XFCE to default settings:
#   xfce4-panel --quit; \
#     pkill xfconfd; \
#     rm -rf ~/.config/xfce4/panel; \
#     rm -rf ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml; \
#     xfce4-panel
#
# Resources:
#   https://docs.xfce.org/xfce/xfconf/xfconf-query
#   https://docs.ansible.com/ansible/latest/collections/community/general/xfconf_module.html
#   https://docs.ansible.com/ansible/latest/collections/community/general/xfconf_info_module.html
#

set -euxo

# ===== xfce4-panel =====

echo "remove 2nd panel" \
  && xfconf-query -c xfce4-panel -p /panels/panel-2 -rR

echo "move 1st panel to the bottom" \
  && xfconf-query -c xfce4-panel -p /panels/panel-1/position -t string -s 'p=4;x=0;y=0' -n

echo "set panel height" \
  && xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 28

echo "change panel icon size" \
  && xfconf-query -c xfce4-panel -p /panels/panel-1/icon-size -t int -s 20

# genmon to show sensors
echo "set panel plugins" \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-1 -t string -s whiskermenu -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-2 -t string -s tasklist -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-3 -t string -s separator -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-4 -t string -s pager -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-5 -t string -s weather -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-6 -t string -s systray -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-7 -t string -s pulseaudio -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-8 -t string -s xfce4-clipman-plugin -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-9 -t string -s notification-plugin -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-10 -t string -s power-manager-plugin -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-11 -t string -s clock -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-12 -t string -s separator -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-13 -t string -s actions -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-90 -t string -s genmon -n

echo "order panel plugins" \
  && xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -a \
    -t int -s 1 -t int -s 2 -t int -s 3 -t int -s 4 -t int -s 5 \
    -t int -s 6 -t int -s 7 -t int -s 8 -t int -s 9 \
    -t int -s 90 \
    -t int -s 10 -t int -s 11 -t int -s 12 -t int -s 13 \
    -n

echo "panel plugin: systray" \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-6/square-icons -t bool -s 'true' -n

echo "panel plugin: clipman" \
  && xfconf-query -c xfce4-panel -p /plugins/clipman/settings/save-on-quit -t bool -s 'false' -n

echo "panel plugin: clock" \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-11/tooltip-format -t string -s '%Y-%m-%d' -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-11/digital-time-font -t string -s 'Sans 10' -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-11/digital-layout -t int -s 3 -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-11/digital-time-format -t string -s '%a %d %b, <b>%H:%M</b>' -n

echo "panel plugin: actions" \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-13/ -t string -s actions -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-13/appearance -t int -s '0' -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-13/ask-confirmation -t bool -s 'true' -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-13/button-title -t int -s 1 -n \
  && xfconf-query -c xfce4-panel -p /plugins/plugin-13/items -t bool -s 'true' -n

# ===== xfce4-keyboard-shortcuts =====

echo "window tile keybindings" \
  && xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Super>Left' -t string -s 'tile_left_key' -n \
  && xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Super>Right' -t string -s 'tile_right_key' -n \
  && xfconf-query -c xfce4-keyboard-shortcuts -p '/xfwm4/custom/<Super>Up' -t string -s 'maximize_window_key' -n

echo "popup startmenu key" \
  && xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Super>Control_L' -t string -s 'xfce4-popup-whiskermenu' -n

echo "lock screen key" \
  && xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Super>l' -t string -s 'xflock4' -n

echo "print screen key" \
  && xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/Print' -t string -s '/usr/bin/flameshot gui' -n

# ===== xfwm4 =====

echo "window button layout" \
  && xfconf-query -c xfwm4 -p /general/button_layout -t string -s "O|HMC"

echo "num of workspaces" \
  && xfconf-query -c xfwm4 -p /general/workspace_count -t int -s 2

echo "disable hiding window when scrolling with mouse" \
  && xfconf-query -c xfwm4 -p /general/mousewheel_rollup -t bool -s 'false'

echo "don't save session" \
  && xfconf-query -n -c xfce4-session -p /general/SaveOnExit -t bool -s false

echo "desktop" \
  && xfconf-query -c xfce4-desktop -p /desktop-icons/icon-size -t int -s 32 -n

# ===== xsettings =====

echo "change theme" \
  && xfconf-query -c xsettings -p /Net/ThemeName -t string -s "Arc-Lighter" -n

echo "change icon theme" \
  && xfconf-query -c xsettings -p /Net/IconThemeName -t string -s "Adwaita" -n

# ===== xfce4-power-manager =====

echo "don't show power label" \
  && xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/show-panel-label -t int -s 0 -n
