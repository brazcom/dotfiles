#!/bin/bash
thunar --class "thunfloat" &
sleep 0.5  # Aspetta che la finestra si apra
# Ottieni le coordinate del cursore
eval $(xdotool getmouselocation --shell)
# Ridimensiona e sposta la finestra
wmctrl -r :ACTIVE: -e 0,$((X-340)),$((Y-220)),680,440
