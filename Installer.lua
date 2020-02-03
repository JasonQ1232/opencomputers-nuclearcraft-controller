mkdir /usr/lib
mkdir /ect/rc.d/ReactorControl
wget -f 'https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/blob/master/lib/reactor.lua' /usr/lib/
wget -f 'https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/blob/master/ReactorControl.lua' /etc/rc.d/ReactorControl/
wget -f 'https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/blob/master/ReactorRelay.lua' /etc/rc.d/ReactorControl/
wget -f 'https://github.com/JasonQ1232/opencomputers-nuclearcraft-controller/blob/master/ReactorListener.lua' /etc/rc.d/ReactorControl/
