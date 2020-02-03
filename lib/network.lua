local component = require("component")
local event = require("event")
local os = require("os")
local modem = component.modem
local thread = require("thread")

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
local messages = {}
local index = 0

function network.recieveTCP()
    local listener = thread.create(function()
        while true do
            print("okay?")
            local _, _, origin, port, _, message = event.pull("modem_message")
            print("i = " .. index)
            messages[index] = {}
            print(index)
            messages[index].origin = origin
            print(origin)
            messages[index].port = port
            print(port)
            messages[index].message = message
            print("okay!")
        end
    end)
    while true do
        if listener:status() == "dead" then
            print("network.recieveTCP() " .. listener:status())
        end
        if last_origin ~= origin and last_port ~= port and last_message ~= message then
            print("wat")
            network.sendTCP(origin, port, message)
            os.sleep(1)
            last_origin = origin
            last_port = port
            last_message = message
        end
        print("hmm")
        os.sleep(0.2)
    end
    print("huh")
    thread.waitForAll({listener})
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