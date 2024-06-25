-- #startup.lua - RENAME THIS FILE TO "startup.lua" TO RUN ON STARTUP.
-- This file is used to run a file on startup. It will run the file specified in the "fileName" variable.

-- Clear the screen
term.clear()
-- Set the cursor position to the top left
term.setCursorPos(1, 1)

-- <!> Set the name of the file to run <!>
local fileName = "twlRednetClient.lua" -- Set the name of the file to run at startup

-- Run the file on startup
local fileExists = fs.exists(fileName)
if fileExists then
   local startupSuccess, startupError = pcall(dofile, fileName)
   if startupSuccess then
      if startupError and startupError.startup then -- Assuming startupError is the loaded table/module
         local success, err = pcall(startupError.startup)
         if not success then
            print("Error running " .. fileName .. ".startup(): " .. tostring(err))
         end
      end
   else
      print("Error: " .. fileName .. " found but failed to load! Please run the script directly and check for errors.")
   end
else
   print("Error: " .. fileName .. " not found!")
end