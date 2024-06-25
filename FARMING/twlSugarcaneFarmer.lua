-- twlSugarcaneFarmer.lua - A simple script to farm SugarCane
-- This script will farm SugarCane by digging the block in front of the turtle and incrementing a counter to keep track of the number of times mined.

-- TODO: Add a function to check if the block in front of the turtle is SugarCane before mining it.

-- Print a message to the console
write("Let's get us some SugarCane eh?")

-- Initialize the variable to keep track of the number of times mined
local timesMined = 0

-- Specify the name of the file to store the mined count
local fileName = "timesMined.txt"

-- Check if the file exists and read the value
if fs.exists(fileName) then
    local file = fs.open(fileName, "r")
    timesMined = tonumber(file.readLine())
    file.close()
end

-- Function to display a message on the turtle's screen
function displayMessage()
    term.clear()
    term.setCursorPos(1,1)
    write("LET'S GET SOME SUGARCANE\nTimes Mined: " .. timesMined .. "\n")
end

-- Call the displayMessage function to show the initial message
displayMessage()

-- Function to perform the farming action
function farming()
    -- Check if there is a block in front of the turtle
    if turtle.detect() then
        -- Increment the timesMined variable
        timesMined = timesMined + 1
        term.clear()
        term.setCursorPos(1,1)
        print ("Times Mined:",timesMined)

        -- Write the value to the file
        local file = fs.open(fileName, "w")
        file.writeLine(tostring(timesMined))
        file.close()

        -- Dig the block in front of the turtle
        turtle.dig()
    end
end

-- Loop indefinitely to continuously perform the farming action
while (true) do
    farming()
end