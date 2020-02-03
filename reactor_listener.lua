local component = require("component")
local computer = require("computer")
local os = require("os")
local event = require("event")
local term = require("term")
local thread = require("thread")
local modem = component.modem
local serialization = require("serialization")
local reactor = require("reactor_control/reactor")

---  SETTINGS  ---
network_port = 244


---END SETTINGS---
term.clear()
os.sleep(1)
modem.open(network_port)



local network_report = thread.create(function()
    while true do
        --print("worker start")
        recieveTCP()
        if message == "reactor_request_report" and port == network_port then
            os.sleep(1)
            local data = serialization.serialize(report_table)
            print(data)
            sendTCP(origin, network_port, data)
        end
        os.sleep(0.2)
    end
end)

local reporter = thread.create(function()
    while true do
        --print("worker start")
        origin, port, message = recieveTCP()
        --print(message)
        if string.find(message, "header=\"reactor_report\"") and port == network_port then
            --print(message)
            local reactor_report = serialization.unserialize(message)
            print_report(reactor_report.name, reactor_report.status, reactor_report.message)
        elseif message == "reactor_alert" then
            os.sleep(1)
            sendTCP(origin, network_port, "reactor_request_report")
            beep(3)
        --term.clear()
        end
        os.sleep(0.1)
    end
end)

while true do
    os.sleep(1)
    if reporter:status() == "dead" then
        print("Reporter " .. reporter:status())
    end
end
