local reactor {


local function beep(count)
  for i=1, count, 1 do
    computer.beep()
  end  
end

local function sendTCP(destination, outbound_port, outbound_message)
  timeout = 5
  while true do
    modem.send(destination, outbound_port, outbound_message)
    local _, _, origin, inbound_port, _, inbound_message = event.pull(timout, "modem_message")
	if origin == destination and inbound_port == outbound_port and inbound_message == outbound_message then
	  print("sent")
	  break
	  print("after break")
	end
	print("timeout")
	return true
  end
end

local function recieveTCP()
  local _, _, origin, port, _, message = event.pull("modem_message")
  for i=0,5,1 do
    modem.send(origin, port, message)
  end
  return origin, port, message
end

local function broadcastTCP(port, message)
  for i=0,5,1 do
    modem.broadcast(port, message)
  end
end

local function print_report(name, status, message)
  print("Reactor: " .. name)
  print("Status: " .. status)
  print("Message: " .. message)
  print()
end



}
return reactor