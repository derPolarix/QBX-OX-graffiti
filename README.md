# FiveM QB/QBX Graffiti Script (OX Inventory Support)
This is a graffiti script for tagging buildings, walls, and more. Gangs can mark their territories, adding a dynamic layer to gang interactions!

# IMPORTANT NOTE
This is only a rewritten version of https://github.com/Kalajiqta/qb-graffiti.git made to fit Ox-Inventory aswell as fixing minor issues. Big Credits to Kalajiqta!
Please read the CHANGES.md for further information.

# JP5M Discord
https://discord.gg/EfzCFzqTRR

## Kalajiqta Preview
https://streamable.com/g4954a

## Kalajiqta Discord
https://discord.gg/sp3cgCy4Ay

## Installation
+ ox-inventory/data/items.lua ->
```lua
    -- Graffitis
    ["spraycan"] = {
        name = "spraycan",
        label = "Spray Can",
        weight = 1000,
        type = "item",
        image = "spraycan.png",
        unique = true,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = "Spray Can",
        metadata = {
            model = "string",
            name = "string"
        }
    },

    ["sprayremover"] = {
        name = "sprayremover",
        label = "Spray Remover",
        weight = 100,
        type = "item",
        image = "sprayremover.png",
        unique = true,
        useable = true,
        shouldClose = true,
        combinable = nil,
        description = "Spray Remover"
    },

```
+ Add graffitis.sql to your database

## Images
![spraycan](https://github.com/Kalajiqta/qb-graffiti/blob/main/images/spraycan.png?raw=true)
![sprayremover](https://github.com/Kalajiqta/qb-graffiti/blob/main/images/sprayremover.png?raw=true)
+ qb-inventory/html/images

## Dependencies
+ [qb(x)-core](https://github.com/qbcore-framework/qb-core)
+ [ox-lib](https://github.com/overextended/ox_lib)
+ [ox-inventory](https://github.com/overextended/ox_inventory)
+ [oxmysql](https://github.com/overextended/oxmysql)

## License
Copyright (c) 2024 Matrix Development

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
