os = require("os")

os.execute("mkdir /etc/rc.d/")
os.execute("mkdir /usr/lib/reactor_control")
os.execute("mkdir /home/reactor_control")

os.execute("mv rc_installer.lua /home/reactor_control/rc_installer.lua")

os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/lib/misc.lua /usr/lib/reactor_control/misc.lua")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/reactor_controller.lua /etc/rc.d/reactor_controller.lua")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/update.lua /home/reactor_control/update.lua")

os.execute("rc reactor_controller enable")
os.execute("reboot")
