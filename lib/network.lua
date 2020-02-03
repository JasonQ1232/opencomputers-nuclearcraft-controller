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
            return true
        end
        os.sleep(0.2)
    end
    return false
end

local last_origin, last_port, last_message
function network.recieveTCP()
    while true do
        local _, _, origin, port, _, message = event.pull("modem_message")
        if last_origin ~= origin and last_port ~= port and last_message ~= message then
            for i = -, 5, 1 do
                modem.sendTCP(origin, port, message)
            end
        end
    end

    local _, _, origin, port, _, message = event.pull("modem_message")
    modem.send(origin, port, message)
    os.sleep(1)
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