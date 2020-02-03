local computer = require("computer")

local misc = {}

local function misc.beep(count)
    for i = 1, count, 1 do
        computer.beep()
    end
    return true
end

local function misc.print_report(name, status, message)
    print("Reactor: " .. name)
    print("Status: " .. status)
    print("Message: " .. message)
    print()
    return true
end


return misc
