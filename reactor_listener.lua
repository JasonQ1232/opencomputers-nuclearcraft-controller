local component = require("component")
local os = require("os")
local term = require("term")
local thread = require("thread")
local modem = component.modem
local serialization = require("serialization")
local network = require("reactor_control/network")
local misc = require("reactor_control/misc")

---  SETTINGS  ---
network_port = 244
---END SETTINGS---
term.clear()
os.sleep(1)
modem.open(network_port)
local network_report = thread.create(netowrk.listen())


function start()
end

local network_report = thread.create(function()
    while true do
        --print("worker start")
        origin, port, message = network.recieveTCP()
        if string.find(message, "header=\"reactor_report\"") and port == network_port and origin ~= modem.address then
            local reactor_report = serialization.unserialize(message)
            misc.print_report(reactor_report.name, reactor_report.status, reactor_report.message)
        elseif message == "reactor_alert" then
            os.sleep(0.5)
            network.sendTCP(origin, network_port, "reactor_request_report")
            misc.beep(3)
        --term.clear()
        end
        os.sleep(0.1)
    end
end)

function stop()
    network_report:kill()
end

while true do
    os.sleep(1)
    if network_report:status() == "dead" then
        print("Reporter " .. network_report:status())
    end
end
