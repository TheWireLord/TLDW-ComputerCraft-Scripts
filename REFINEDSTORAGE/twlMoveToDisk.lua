-- twlMoveToDisk.lua - A script to move items from the RS system to a chest connected to the RS Bridge

-- Open a log file in append mode
local logFile = fs.open("rsOperationLog.txt", "a")

-- Function to log messages both to console and to a file
local function log(message)
    print(message)  -- Print to console
    logFile.writeLine(message)  -- Write to log file
    logFile.flush()  -- Ensure the message is written immediately
end

-- Function to find and return the peripheral name of the RS Bridge
local function findRSBridge()
    local peripherals = peripheral.getNames()
    for _, name in ipairs(peripherals) do
        if peripheral.getType(name) == "rsBridge" then
            log("RS Bridge found: " .. name)
            return name
        end
    end
    log("No RS Bridge connected.")
    return nil
end

-- Function to export items from the RS system to a chest
local function exportItemsToChest(rsBridgeName)
    local rsBridge = peripheral.wrap(rsBridgeName)
    -- List all items in the RS system
    local items = rsBridge.listItems()
    for _, item in ipairs(items) do
        -- Export each item to the chest connected to the RS Bridge
        -- Assuming exportItem is a method to export items to an external inventory and "NORTH" is the direction of the chest
        local exported = rsBridge.exportItem(item, "NORTH", item.amount)
        if exported > 0 then
            log("Exported " .. exported .. " of " .. item.name .. " to the chest.")
        else
            log("Failed to export " .. item.name)
        end
    end
end

-- Main function
local function main()
    log("Starting item export operation to the chest...")
    local rsBridgeName = findRSBridge()
    if rsBridgeName then
        exportItemsToChest(rsBridgeName)
    else
        log("Failed to find RS Bridge.")
    end
    log("Item export operation completed.")
end

main()

-- Close the log file at the end of the script
logFile.close()