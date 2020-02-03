os = require("os")

os.execute("mkdir /usr/lib/reactor_control")
os.execute("mkdir /ect/rc.d/reactor_control")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/lib/reactor.lua /usr/reactor_control/lib/")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/reactor_controller.lua /etc/rc.d/reactor_control/")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/reactor_relay.lua /etc/rc.d/reactor_control/")
os.execute("wget -f https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/raw/master/reactor_listener.lua /etc/rc.d/reactor_control/")
