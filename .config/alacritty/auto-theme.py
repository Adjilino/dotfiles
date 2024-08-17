import darkdetect, time
import os

home = os.path.expanduser('~')
workDirectory = home + "/.config/alacritty/"

def detectTheme():
    data = ""

    if darkdetect.isDark():
        with open(workDirectory + "alacritty-dark.toml", "r") as f:
            data = f.read() 
    else:
        with open(workDirectory + "alacritty-light.toml", "r") as f:
            data = f.read()

    if data:
        with open(workDirectory + "alacritty.toml", "w") as f:
            f.write(data)

    time.sleep(1)
    detectTheme()

detectTheme()

