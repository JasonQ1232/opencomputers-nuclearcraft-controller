local component = require("component")
local computer = require("computer")
local io = require("io")
local os = require("os")
local event = require("event")
local term = require("term")
local thread = require("thread")
local serialization = require("serialization")
local modem = component.modem
local reactor = require("reactor")

---  SETTINGS  ---


reactor_temp_max_percent = 0.25
reactor_cap_max_percent = 0.80
reactor_cap_safe_percent = 0.05
network_port = 244


---END SETTINGS---
term.clear()
os.sleep(1)

local reactor_temp_safe
local reactor_cap_safe
local report_table = {} -- Name, Status, Msg

function start()

end

if not component.isAvailable("nc_fission_reactor") then
  print("Reactor not connected. Please connect the computer to the fission reactor.")
  return
else
  print("Reactor detected.")
  print("");
end

reactor = component.nc_fission_reactor
reactor.deactivate()

report_table.header = "reactor_report"
report_table.name = string.gsub(math.floor(reactor.getLengthX()) .. math.floor(reactor.getLengthY()) .. math.floor(reactor.getLengthZ()), "%p", "")
report_table.status = "n/a"
report_table.message = "n/a"

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

local network_alert = thread.create(function()
  local lastStatus
  while true do
  	if report_table.status ~= lastStatus then
	  broadcastTCP(network_port, "reactor_alert")
	  print("reactor alert")
	end
	lastStatus = report_table.status
	os.sleep(0.1)
  end
 end)


local function resume_ask()
  os.sleep(3)
  local response
  io.write("Restart reactor (y/n)? ")
  while true do
    response = io.read()
    if response == "y" then
      print("Restarting reactor.")
      print("")
      return
    elseif response == "n" then
      print("Termiating")
      os.exit()
    end
  end
end

local function reactor_check_heat() -- Percent is a decimal
  local currentLevel = reactor.getHeatLevel()
  local reactorMax = reactor.getMaxHeatLevel()
  local percent = reactor_temp_max_percent
  local isSafe

  if currentLevel > (percent*reactorMax) then
    report_table.status = "CRITICAL ERROR. USER INPUT REQUIRED"
	report_table.message = "Reactor temperature exceeding specified limits."
    print("Reactor temperature exceeding specified limits.")
    print("Shutting down reactor.")
    print("")
    reactor.deactivate()
    beep(5)
    isSafe = false
    resume_ask()
  else
    isSafe = true
  end
  return isSafe
end

local function reactor_check_power() -- Percent is a decimal
  local currentLevel = reactor.getEnergyStored()
  local reactorMax = reactor.getMaxEnergyStored()
  local maxPercent = reactor_cap_max_percent
  local safePercent = reactor_cap_safe_percent
  local isSafe

  if currentLevel > (maxPercent*reactorMax) then
	report_table.status = "Reactor shutdown."
	report_table.message = "Reactor capacitor exceeding specified limits."
    print("Reactor capacitor exceeding specified limits.")
    print("Shutting down reactor.")
    print("")
    reactor.deactivate()
    beep(3)
    isSafe = false
    while currentLevel > (safePercent*reactorMax) do
      os.sleep(1)
      currentLevel = reactor.getEnergyStored()
    end
  else
    isSafe = true
  end
  return isSafe
end

local function reactor_start(reactor_temp_safe, reactor_cap_safe)
  local temp_safe = reactor_temp_safe
  local cap_safe = reactor_cap_safe

  if temp_safe == true and cap_safe == true and reactor.isProcessing() == false then 
    print("Reactor reports safe. Starting reactor")
	report_table.status = "Reactor online"
	report_table.message = "Reactor reports safe."
    print("")
    reactor.activate()
  end
end

while true do
  os.sleep(0.2)
  
  if network_report:status() == "dead" or network_alert:status() == "dead" then
	print("Reporter " .. network_report:status())
	print("Alert " .. network_alert:status())
  end
  
  reactor_temp_safe = reactor_check_heat()
  reactor_cap_safe = reactor_check_power()

  reactor_start(reactor_temp_safe, reactor_cap_safe)
end