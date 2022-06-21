#!/bin/bash
luastatus -b dwm -B separator= \
    ~/.config/luastatus/module/battery.lua \
    ~/.config/luastatus/module/wifi.lua \
    ~/.config/luastatus/module/mem-usage.lua \
    ~/.config/luastatus/module/cpu-usage.lua \
    ~/.config/luastatus/module/network-rate.lua \
    ~/.config/luastatus/module/time-date.lua
