#!/bin/bash
# My github https://github.com/IamJony/
# Blue light filters

display=$(xrandr | grep " connected" | awk '{ print$1 }')

# temperature color (in K)
default_temperature=6500
temperature=${1:-$default_temperature}

red_correction=$(echo "scale=3; 1.0 - (1.0 * ($temperature - 6500) / 10000)" | bc)
green_correction=$(echo "scale=3; 1.0 - (0.5 * ($temperature - 6500) / 10000)" | bc)
blue_correction=$(echo "scale=3; 1.0 - (0.25 * ($temperature - 6500) / 10000)" | bc)

# get brightnessac
current_brightness=$(xrandr --verbose | grep -i brightness | cut -f2 -d ' ')

function on_filtro {
    xrandr --output $display --gamma $red_correction:$green_correction:$blue_correction --brightness $current_brightness
}

function off_filtro {
    xrandr --output $display --gamma 1:1:1 --brightness $current_brightness
}

if [ "$1" == "--off" ]; then
    off_filtro
else
    on_filtro
fi

