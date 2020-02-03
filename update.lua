os = require("os")

os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/rc_installer.lua /home/reactor_control/rc_installer.lua")
os.execute("/home/reactor_control/rc_installer.lua")