#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Clipboard Manager using cliphist
#
## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
## style-6     style-7     style-8     style-9     style-10
## style-11    style-12    style-13    style-14    style-15

dir="$HOME/.config/rofi/launchers/type-2"
theme='style-5'

## Run clipboard manager with theme
cliphist list | rofi -dmenu -theme ${dir}/${theme}.rasi | cliphist decode | wl-copy 
