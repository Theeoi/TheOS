## TheOS - Scripts
These are some custom scripts I use when I could not find other solutions.

### Backlight
The backlight.sh script allows for more control over the screen brightness.
Implement by running the script on a keybind. The first argument is either '+' och '-'.
```
./backlight.sh +/-
```

### Pythonrc
Storing the python configs in a folder away from $HOME requires a script.
Copy file to $HOME/.cache/python/pythonrc to implement.

### Rotate-screen
The rotate-screen script allows for automatic rotation of the screen and touch inputs with an inbuilt accelerometer.
The script is well documented and is sourced from https://github.com/linux-surface/linux-surface/tree/master/contrib/rotate-screen
For automatic detection run:
```
./rotate-screen.sh screen
```

### Start_jack
JACK is an audio interface for professional audio.
Run this script at startup to enable JACK by default.

### Wifidrivers
If running an ethernet cable to your computer is hard you need a wifi-dongle.
These often don't work out-of-the-box and therefore need a script to get them
working.
Simply run the script once and they are installed. The script needs to be
re-run every kernel update.
