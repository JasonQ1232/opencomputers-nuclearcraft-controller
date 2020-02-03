local component = require("component")
local event = require("event")
local os = require("os")
local modem = component.modem

local network = {}

function network.sendTCP(destination, outbound_port, outbound_message)
    while true do
        modem.send(destination, outbound_port, outbound_message)
        local _, _, origin, inbound_port, _, inbound_message = event.pull(5, "modem_message")
        if origin == destination and inbound_port == outbound_port and inbound_message == outbound_message then
            print("sent")
            return true
        end
        os.sleep(0.2)
    end
    return false
end

function network.recieveTCP()
    local _, _, origin, port, _, message = event.pull("modem_message")
    for i = 0, 5, 1 do
        modem.send(origin, port, message)
        os.sleep(0.2)
    end
    return origin, port, message
end

function network.broadcastTCP(port, message)
    for i = 0, 5, 1 do
        modem.broadcast(port, message)
        os.sleep(0.2)
    end
    return true
end


return network