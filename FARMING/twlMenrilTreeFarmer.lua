local movements = {} -- Table to store turtle movements
local isChopping = false -- Variable to track if chopping is ongoing

-- List of accepted blocks
local acceptedBlocks = {
    ["minecraft:log"] = true,
    ["integrateddynamics:menril_log_filled"] = true,
    ["integrateddynamics:menril_log"] = true
}

-- Function to check and dig only if the block is accepted
local function digIfAccepted()
    local success, data = turtle.inspect()
    if success and acceptedBlocks[data.name] then
        turtle.dig()
    end
end

-- Function to handle turtle fuel level
local function checkFuelLevel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" or fuelLevel > 0 then
        print("Fuel level: " .. fuelLevel)
    else
        print("Fuel level too low. Refuel required.")
        return false
    end
    return true
end

-- Function to refuel the turtle
local function refuelTurtle()
    for slot = 1, 16 do
        turtle.select(slot)
        local item = turtle.getItemDetail()
        if item and item.name:find("log") then
            turtle.refuel()
            print("Refueled turtle.")
            return true
        end
    end
    print("No logs in inventory.")
    return false
end

-- Function for Stage Two chopping logic
local function chopStageTwo()
    local detectLogsAbove = turtle.detectUp() -- Check for logs above
    while detectLogsAbove do
        if turtle.detect() then
            for i = 1, 4 do
                turtle.turnLeft()
                os.sleep(0.5) -- Pause for turning before detecting
                digIfAccepted()
            end
        else
            turtle.up()
            table.insert(movements, "up")
        end
        if turtle.detectUp() then
            turtle.digUp()
            turtle.up()
            table.insert(movements, "up")
        else
            detectLogsAbove = false -- No more logs detected above
        end
    end
    local function moveToInitialPosition()
        for i = #movements, 1, -1 do
            local movement = movements[i]
            if movement == "forward" then
                turtle.back()
            elseif movement == "up" then
                turtle.down()
            end
        end
    end
    print("Returning to start position...")
    moveToInitialPosition() -- After Stage Two, return to start position
    print("Returned to start position.")
    -- Check for sapling and place when back at start position
    local function placeSapling()
        for slot = 1, 16 do
            turtle.select(slot)
            local item = turtle.getItemDetail()
            if item and item.name:find("sapling") then
                turtle.forward()
                turtle.place()
                turtle.back()
                print("Sapling planted!")
                return true -- Sapling placed successfully
            end
        end
        print("No sapling in inventory.")
        return false -- No sapling found
    end
    if placeSapling() then
        -- Refuel
        refuelTurtle()
        -- Turn left, put everything in chest except sapling, turn right and wait for log detection
        turtle.turnLeft()
        for slot = 1, 16 do
            turtle.select(slot)
            local item = turtle.getItemDetail()
            if item and not item.name:find("sapling") then
                turtle.drop()
            end
        end
        turtle.turnRight()
        -- Wait until a Menril log is detected
        while true do
            local success, blockData = turtle.inspect()
            if success and blockData.name == "integrateddynamics:menril_log" then
                print("Menril log detected. Initiating log detection...")
                break -- Exit the loop to start the detect log process
            end
            os.sleep(10) -- Wait for 10 seconds before checking again
        end
    end
end

-- Function for Stage One chopping logic
local function chopStageOne()
    local logDetectionStartTime = os.time() -- Start time for log detection
    while turtle.detect() do
        digIfAccepted()
        turtle.forward()
        table.insert(movements, "forward")
    end
    turtle.back() -- Move back before final check and starting Stage Two
    table.insert(movements, "back")
    -- Turn left 4 times to check for logs
    for i = 1, 4 do
        turtle.turnLeft()
        os.sleep(0.5) -- Pause for turning before detecting
        digIfAccepted()
    end
    print("No log detected. Initiating Stage Two...")
    chopStageTwo() -- Start the next chopping stage
end

-- Function to scan for logs in front of the turtle and start chopping
local function detectLog()
    while true do
        if turtle.detect() then
            print("Log detected! Starting chopping...")
            isChopping = true -- Update chopping status
            chopStageOne()
            isChopping = false -- Reset chopping status once done
        else
            os.sleep(1)
        end
    end
end

checkFuelLevel() -- Check the fuel level before starting
while not checkFuelLevel() do
    if refuelTurtle() then
        checkFuelLevel() -- Check fuel level after refueling
    else
        print("Waiting for logs to refuel...")
        os.sleep(10)
    end
end
print("Ready to start. Waiting for log detection...")
-- Start the log detection process
detectLog()