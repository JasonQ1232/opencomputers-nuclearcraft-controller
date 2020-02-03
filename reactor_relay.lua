local component = require("component")
local computer = require("computer")
local os = require("os")
local event = require("event")
local tunnel = component.tunnel
local modem = component.modem
local term = require("term")
local thread = require("thread")
local serialization = require("serialization")
local reactor = require("reactor")

---  SETTINGS  ---

network_port = 244

---END SETTINGS---

term.clear()
os.sleep(1)
modem.open(network_port)

local function beep(count)
  for i=1, count, 1 do
    computer.beep()
  end  
end

local listen = thread.create(function()
  while true do
	print("worker start")
	local _, from, port, _, _, message = event.pull("modem_message")
	local report_table = serialization.unserialize(message)
	print(port)
	if port == 0 then
		print(report_table.name)
		print(report_table.status)
		print(report_table.message)
	end
	os.sleep(0.1)
  end
end)

while true do
  os.sleep(0.2)
  if listen:status() == "dead" then
	print("Listen " .. listen:status())
  end
end

function start()

end

function stop()
  os.exit()
end