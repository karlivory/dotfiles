#!/usr/bin/env bash

rm /tmp/screenshot.png
flameshot full -p /tmp/screenshot.png
convert /tmp/screenshot.png -resize 50% ~/git/dotfiles/docs/screenshot.png
