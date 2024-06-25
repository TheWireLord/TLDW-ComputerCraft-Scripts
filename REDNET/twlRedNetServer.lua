-- twlRedNetServer.lua - This file is used to receive messages from the client and run them as commands on the server.
-- Useful for remote control of a computer using rednet.

rednet.open("left")

-- Clear the screen
term.clear()
term.setCursorPos(1,1)

-- TODO: Add a check to see if the connection was made
print("Connection made")

while true do
   -- Receive message from sender
   senderID, message, distance = rednet.receive()

   -- Check if the message is "exit"
   if message == "exit" then
      break
   end

   -- Run the command received as the message
   shell.run(message)
end

rednet.close("right")