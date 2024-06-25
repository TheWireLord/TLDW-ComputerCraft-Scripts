
-- twlRednetClient - Connects to the rednet server on the receiving PC.
-- It can then send messages to the receiving PC and run commands on it.

-- Open the rednet modem on the back side of the computer
-- <!> Change the side if the modem is not on the back side <!>
rednet.open("back")
while true do
   input = read()
   rednet.send(4, input)
   if input == "exit" then
      break
   end
end
rednet.close("back")