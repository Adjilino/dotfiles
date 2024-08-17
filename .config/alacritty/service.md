### Create service from python

To have it run as a daemon process, create a plist file, <br>`~/Library/LaunchAgents/com.adjilino.osx.alacritty.auto-theme.plist`

Then use launchctl to load the plist from a terminal:<br>
`launchctl load ~/Library/LaunchAgents/com.adjilino.osx.alacritty.auto-theme.plist`

If you want to remove the script, you can use the unload command of launchctl:<br>
`launchctl unload ~/Library/LaunchAgents/com.adjilino.osx.alacritty.auto-theme.plist`