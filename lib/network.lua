local component = require("component")
local event = require("event")
local os = require("os")
local modem = component.modem
local thread = require("thread")

local network = {}

function network.sendTCP(destination, outbound_port, outbound_message)
    while true do
        modem.send(destination, outbound_port, outbound_message)
        for i=0, 5, 1 do
            local _, _, origin, inbound_port, _, inbound_message = event.pull(5, "modem_message")
            if origin == destination and inbound_port == outbound_port and inbound_message == outbound_message then
                return true
            end
        end
        os.sleep(0.2)
    end
    return false
end

local last_origin, last_port, last_message
local messages = {}
local index = 1

function network.recieveTCP()
    local listener = thread.create(function()
        while true do
            print("okay?")
            local _, _, origin, port, _, message = event.pull("modem_message")
            --print("i = " .. index)
            messages[index] = {}
            --print(index)
            messages[index].origin = origin
            --print(origin)
            messages[index].port = port
            --print(port)
            messages[index].message = message
            --print(message)
            index = index + 1
            --print(index)
            os.sleep(0.1)
        end
    end)
    while true do
        if listener:status() == "dead" then
            print("network.recieveTCP() " .. listener:status())
        end
        print(#messages .. " new messages") 
        if #messages > 0 then
            print("whyyyy")
            for i = 1, #messages, 1 do

                local origin = messages[i].origin
                local port = messages[i].port
                local message = messages[i].message

                if last_origin ~= origin and last_port ~= port and last_message ~= message then
                    print("original")
                    network.sendTCP(origin, port, message)
                    os.sleep(1)
                end
                last_origin = origin
                print(last_origin)
                last_port = port
                print(last_port)
                last_message = message
                print(last_message)
                table.remove(messages, i)
            end
        end
        --print("hmm")
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
