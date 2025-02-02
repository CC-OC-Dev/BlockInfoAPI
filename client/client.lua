function getBlockData(XYZ, modem_pos, h_id, h_net)
    if XYZ == nil or modem_pos == nil or h_id == nil then
        error("Error: One or more required parameters (XYZ, modem_pos, h_id) are missing.")
    end
    
    if h_net == nil then h_net = "admin" end
    
    if not rednet.isOpen(modem_pos) then
        rednet.open(modem_pos)
    end
    
    local send = rednet.send(h_id, XYZ, h_net)
    if not send then
        error("Error: Failed to send message. Ensure the server is online, operational, and within modem range.")
    end
    
    local id, message = rednet.receive(nil, 5)
    
    if id == nil then
        error("Error: No response received from the server within the timeout period (5s).")
    end

    if type(message) == "string" and string.find(message, "Error:") then
        error(message)
    end

    return message
end
