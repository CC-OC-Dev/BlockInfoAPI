os.loadAPI("client.lua")
local data = client.getBlockData("-289 -922 10", "top", 13)
print(data.name)

-- Chest
function printTable(tbl, indent)
    indent = indent or ""
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            print(indent .. tostring(k) .. ":")
            printTable(v, indent .. "  ")
        else
            print(indent .. tostring(k) .. ": " .. tostring(v))
        end
    end
end

printTable(data.nbt.Items)
