# BlockInfoAPI

**BlockInfoAPI** is a Lua API for **ComputerCraft**, designed to provide detailed block information using a command computer. Since standard and advanced computers lack access to `commands.getBlockInfo`, this API bridges the gap by allowing clients to request block data remotely.

## ⚙️ How It Works
A **command computer** runs the server-side script, handling requests from clients. Clients send coordinates and receive full block information, including metadata and NBT data.

## 📥 Installation

### 🔧 Server-Side Installation (Command Computer)
1. Open the **command computer** in ComputerCraft.
2. Run the following command to download the server script:
   ```
   pastebin get EtAZhCq0 server.lua
   ```
3. Start the server script:
   ```
   server.lua
   ```
NOTE:
   **It is recommended to rename the script to startup.lua or create a file called startup.lua and include
   `shell.run("server.lua")`
   This way, the server will start automatically when entering the world.**


### 💻 Client-Side Installation (Standard or Advanced Computer)
1. Open the **client computer**.
2. Run the following command to download the client script:
   ```
   pastebin get z3qkLEaH client.lua
   ```
3. Import the API in your script and use the function:

## 📜 Client-Side Usage
```lua
os.loadAPI("client.lua")
local blockData = client.getBlockData("X Y Z", modem_pos, h_id, h_net)
print(blockData.name) -- Prints block name
print(blockData.nbt)  -- Access block's NBT data
```

### Function Parameters:
- **`coordinates`** *(string)* – Block position in the format `"X Y Z"` (space-separated).
- **`modem_pos`** *(string)* – Side of the computer where the modem is attached (`back`, `top`, `right`, etc.).
- **`h_id`** *(number)* – The Rednet ID of the server.
- **`h_net`** *(string, optional)* – The Rednet network name (default: `admin`).

## 🔄 API Response
The function returns a Lua table containing block details, which can be accessed directly:
```lua
blockData.name  -- "minecraft:chest"
blockData.state.waterlogged  -- false
blockData.nbt.Items  -- Table of stored items
...
```
Example with a chest:
![image](https://github.com/user-attachments/assets/9b967717-478b-4a03-88d0-d5007a9c5bb2)
![image](https://github.com/user-attachments/assets/fbe7b043-9b89-464d-b301-f93d8139d49e)

<details>
  <summary><kbd> <br> Code to display content <br> </kbd></summary>

  ```lua
os.loadAPI("GBD.lua")
local data = GBD.getBlockData("-289 -922 10", "top", 13)
print(data.name)

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

  ```
</details>

## 📬 Support & Contact
For issues or suggestions:
- Discord: **tokishu** (preferred)
- Telegram: [@TodNacht](https://t.me/TodNacht)
- Or open an Issue in the repository!

---
*Enhance your ComputerCraft automation with BlockInfoAPI!*
