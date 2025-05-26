#!/bin/bash
# My github https://github.com/IamJony/
# Adjust brightness xrandr

display=$(xrandr | grep " connected" | awk '{ print$1 }')
current_brightness=$(xrandr --verbose | grep -i brightness | cut -f2 -d ' ')
increment=0.04

function up {  
new_brightness=$(echo "$current_brightness + $increment" | bc)

xrandr --output $display --brightness $new_brightness
}

function down {
new_brightness=$(echo "$current_brightness - $increment" | bc)

xrandr --output $display --brightness $new_brightness


}

# Scripts parameters

if  [[ $1 = "--up" ]]; then
	up
	

elif  [[ $1 = "--down" ]]; then
	down
	
    
else	
echo ""

fi

exit 0 
