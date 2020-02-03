local component = require("component")
local modem = component.modem

local network = {}

local function network.sendTCP(destination, outbound_port, outbound_message)
    timeout = 5
    while true do
      modem.send(destination, outbound_port, outbound_message)
      local _, _, origin, inbound_port, _, inbound_message = event.pull(timout, "modem_message")
      if origin == destination and inbound_port == outbound_port and inbound_message == outbound_message then
        print("sent")
        return true
        print("it broke")
      end
      return false
    end
  end
  
  local function network.recieveTCP()
    local _, _, origin, port, _, message = event.pull("modem_message")
    for i=0,5,1 do
      modem.send(origin, port, message)
    end
    return origin, port, message
  end
  
  local function network.broadcastTCP(port, message)
    for i=0,5,1 do
      modem.broadcast(port, message)
    end
    return true
  end