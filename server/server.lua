local configFile = "BlockInfoAPI/config.txt"
local modem, protocol, hostName

if fs.exists(configFile) then
    local file = fs.open(configFile, "r")
    modem = file.readLine()
    protocol = file.readLine()
    hostName = file.readLine()
    file.close()
else
    term.clear()
    term.setCursorPos(1,1)
    print("Enter modem side (e.g., top, bottom, left, right, front, back):")
    modem = read()
    if modem == "" then modem = "top" end
    
    print("Enter protocol (default: admin):")
    protocol = read()
    if protocol == "" then protocol = "admin" end
    
    print("Enter host name (default: blockInfo):")
    hostName = read()
    if hostName == "" then hostName = "blockInfo" end
    
    local file = fs.open(configFile, "w")
    file.writeLine(modem)
    file.writeLine(protocol)
    file.writeLine(hostName)
    file.close()
end

local id = os.getComputerID()
local debugMode = false
local d = "[ DEBUG ] "
rednet.open(modem)
rednet.host(protocol, hostName)
term.clear()
term.setCursorPos(1,1)
print("=======================[API]=======================")
print("Listening on ID #" .. id)
print("Script by Tok1shu :3")
print("Repo: https://github.com/CC-OC-Dev/BlockInfoAPI")
print()

function printColor(text, color)
    local txtColor = term.getTextColor()
    term.setTextColor(color)
    print(text)
    term.setTextColor(txtColor)
end

function closeAPI(reason)
    if reason then
        printColor(reason, colors.red)
        print()
    end
    printColor("Stopping the API!", colors.red)
    printColor("Closing the host and turning off the modem...", colors.red)
    printColor("Successfully completed.", colors.red)
    printColor("Goodbye  :3", colors.yellow)
    rednet.unhost(protocol)
    rednet.close(modem)
    error()
end

if not commands then
    printColor("commands API is unavailable (not a Command Computer?)", colors.red)
    print()
    closeAPI()
end

function convertToC(coordinates)
    local parts = {}
    for part in string.gmatch(coordinates, "-?%d+") do
        table.insert(parts, tonumber(part))
    end
    if #parts ~= 3 then
        return nil, "Invalid coordinates format (expected: X Y Z)"
    end
    return parts
end

function getBlockInfo(x, y, z)
    if debugMode then
        print(d .. "getBlockInfo received data: " .. x .. " " .. y .. " " .. z)
    end
    local success, blockInfo = pcall(commands.getBlockInfo, x, y, z)
    if not success then
        return nil, "Failed to get block info"
    end
    local function buildResult(tbl)
        local result = {}
        for key, value in pairs(tbl) do
            if type(value) == "table" then
                result[key] = buildResult(value)
            else
                result[key] = value
            end
        end
        return result
    end
    return buildResult(blockInfo)
end

local queue = {}

function requestListener()
    while true do
        local senderId, message = rednet.receive()
        table.insert(queue, {id = senderId, msg = message})
        printColor(("Request from #%d: %s"):format(senderId, message), colors.yellow)
    end
end

function requestProcessor()
    while true do
        if #queue > 0 then
            local request = table.remove(queue, 1)
            local senderId = request.id
            local message = request.msg

            if not string.find(message, "%s") then
                rednet.send(senderId, "Bad request: Coordinates must be space-separated")
                printColor("Bad request", colors.orange)
            else
                local xyz, err = convertToC(message)
                if not xyz then
                    rednet.send(senderId, "Bad request: " .. err)
                    printColor("Error: " .. err, colors.orange)
                else
                    local blockData, err = getBlockInfo(xyz[1], xyz[2], xyz[3])
                    if blockData then
                        rednet.send(senderId, blockData)
                        printColor("Data returned successfully!", colors.lime)
                    else
                        rednet.send(senderId, "Error: " .. err)
                        printColor("Error: " .. err, colors.orange)
                    end
                end
            end
        else
            sleep(0)
        end
    end
end

-- NOTE: FIX IT
function terminateListener() -- I tried to fix that :(
    while true do
        os.pullEvent("terminate")
        closeAPI("Terminate signal received")
    end
end

parallel.waitForAny(requestListener, requestProcessor, terminateListener)
