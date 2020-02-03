local component = require("component")
local computer = require("computer")
local event = require("event")
local os = require("os")
local modem = component.modem
local thread = require("thread")


local network = {}



local messages = {}
function network.listen()
    while true do
        --print("okay?")
        local _, _, origin, port, _, message = event.pull("modem_message")
        i = #messages + 1
        messages[i] = {}
        messages[i].origin = origin
        messages[i].port = port
        messages[i].message = message
        messages[i].uptime = computer.uptime()
        print(message .. " : " .. #messages)
        os.sleep(0.1)
    end
    return true
end

function network.search_table(message)
    local results = {}
    print("something requsted a search! woop-woop")
    if #messages > 0 then
        for i=1, #messages, i do
            if messages[i].message == message then
                table.insert(results, i)
            end
        end
        return results
    else
        return nil
    end
end

function network.sendTCP(destination, outbound_port, outbound_message)
    while true do
        local send_time = computer.uptime()
        print("pre modem.send")
        modem.send(destination, outbound_port, outbound_message)
        print("post modem.send")
        local search_results = search_table(outbound_message)
        print("post search")
        if #results > 0 then
            for i=0, #results, i do
                print(messages[i].message)
            end
        end
        post("filter")

        print("network sending")
        for i=0, 5, 1 do
            local _, _, origin, inbound_port, _, inbound_message = event.pull(5, "modem_message")
            print("network send.listen")
            if origin == destination and inbound_port == outbound_port and inbound_message == outbound_message then
                return true
            end
        end
        os.sleep(0.2)
    end
    return false
end



local last_origin, last_port, last_message
function network.recieveTCP()
    while true do
        print(#messages .. " new messages") 
        if #messages > 0 then
            print("whyyyy " .. #messages)
            for i = 1, #messages, 1 do
                print("preorigin" .. messages[i].origin)
                local origin = messages[i].origin
                print("postorigin")
                local port = messages[i].port
                local message = messages[i].message
                print("pre if")
                if last_origin ~= origin and last_port ~= port and last_message ~= message then
                    print("pre send")
                    network.sendTCP(origin, port, message)
                    print("post send")
                    os.sleep(1)
                end
                print("post if")
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
