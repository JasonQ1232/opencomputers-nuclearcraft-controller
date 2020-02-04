local component = require("component")
local io = require("io")
local os = require("os")
local event = require("event")
local term = require("term")
local thread = require("thread")
local misc = require("reactor_control/misc")

---  SETTINGS  ---
reactor_temp_max_percent = 0.25
reactor_cap_max_percent = 0.80
reactor_cap_safe_percent = 0.05


---END SETTINGS---
term.clear()
os.sleep(1)

local reactor_temp_safe
local reactor_cap_safe

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

local function reactor_check_heat()-- Percent is a decimal
    local currentLevel = reactor.getHeatLevel()
    local reactorMax = reactor.getMaxHeatLevel()
    local percent = reactor_temp_max_percent
    local isSafe
    
    if currentLevel > (percent * reactorMax) then
        report_table.status = "CRITICAL ERROR. USER INPUT REQUIRED"
        report_table.message = "Reactor temperature exceeding specified limits."
        print("Reactor temperature exceeding specified limits.")
        print("Shutting down reactor.")
        print("")
        reactor.deactivate()
        misc.beep(5)
        isSafe = false
        resume_ask()
    else
        isSafe = true
    end
    return isSafe
end

local function reactor_check_power()-- Percent is a decimal
    local currentLevel = reactor.getEnergyStored()
    local reactorMax = reactor.getMaxEnergyStored()
    local maxPercent = reactor_cap_max_percent
    local safePercent = reactor_cap_safe_percent
    local isSafe
    
    if currentLevel > (maxPercent * reactorMax) then
        print("Reactor capacitor exceeding specified limits.")
        print("Shutting down reactor.")
        print("")
        reactor.deactivate()
        misc.beep(3)
        isSafe = false
        while currentLevel > (safePercent * reactorMax) do
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
        print("")
        reactor.activate()
    end
end

while true do
    os.sleep(0.2)
    
    reactor_temp_safe = reactor_check_heat()
    reactor_cap_safe = reactor_check_power()
    
    reactor_start(reactor_temp_safe, reactor_cap_safe)
end
