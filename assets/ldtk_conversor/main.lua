local json = require "json"

local filename = assert(arg[1], "NO FILENAME GIVEN.")

local f = assert(io.open(filename, "r"), "FILE DOES NOT EXIST.")
local map = json.decode(f:read("*all"))
f:close()

--for _, level in ipairs(map.levels) do
    local level = map.levels[1]
    local out_level = {
        width = level.pxWid,
        height = level.pxHei,
        uid = level.uid,
        tiles = {}
    }

    for _, layer in ipairs(level.layerInstances) do
        if layer.__type == "Tiles" then
            for _, tiles in ipairs(layer.gridTiles) do
                table.insert(out_level.tiles, {
                    tiles.px[1],  tiles.px[2], 
                    tiles.src[1], tiles.src[2],
                    layer.__gridSize, layer.__gridSize
                })
            end
        end
    end
--end

local f = assert(io.open(filename:sub(1, #filename-5)..".json", "r+"), "OUTPUT FILE COULD NOT BE OPENED.")
f:write(json.encode(out_level))
f:close()