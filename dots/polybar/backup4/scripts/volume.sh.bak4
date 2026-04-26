#!/bin/bash


volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" = "true" ]; then
    echo " "
else
    echo " $volume%"
fi

