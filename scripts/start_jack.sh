#!/bin/sh

# Startup script for initializing JACK - a high-end audio interface
# This is needed for audio production on linux machines.
# Setup to run on startup if of interest.

jack_control start
jack_control ds alsa
jack_control dps device hw:iTwo
jack_control dps rate 48000
jack_control dps nperiods 3
jack_control dps period 64
sleep 10
a2j_control --ehw
a2j_control --start
sleep 10
qjackctl &
