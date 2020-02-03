local component = require("component")
local computer = require("computer")
local os = require("os")
local event = require("event")
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



local network_report = thread.create(function()
    while true do
        --print("worker start")
        local origin, port, message = network.recieveTCP()
        if message == "reactor_request_report" and port == network_port then
            print("msg")
            local data = serialization.serialize(report_table)
            print(data)
            os.sleep(1)
            network.sendTCP(origin, network_port, data)
        end
        os.sleep(0.2)
    end
end)


while true do
    os.sleep(1)
    if network_report:status() == "dead" then
        print("Reporter " .. network_report:status())
    end
end
