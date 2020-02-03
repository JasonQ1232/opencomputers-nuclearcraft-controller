os = require("os")

os.execute("mkdir /etc/rc.d/reactor_control/")
os.execute("mkdir /home/reactor_control")

os.execute("mv rc_installer.lua /home/reactor_control/rc_installer.lua"

os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/lib/reactor.lua /usr/lib/reactor_control/reactor.lua")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/reactor_controller.lua /etc/rc.d/reactor_control/controller.lua")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/reactor_relay.lua /etc/rc.d/reactor_control/relay.lua")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/reactor_listener.lua /etc/rc.d/reactor_control/listener.lua")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/update.lua /etc/rc.d/reactor_control/update.lua")