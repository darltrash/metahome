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
        tiles = {},
        entities = {}
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
        elseif layer.__type == "Entities" then
            for _, entity in ipairs(layer.entityInstances) do
                local offset = {
                    x = entity.__pivot[1] * entity.width,
                    y = entity.__pivot[2] * entity.height
                }

                local tw, th = entity.width, entity.height
                if entity.__tile then
                    tw = entity.__tile.w
                    th = entity.__tile.h
                end

                table.insert(out_level.entities, {
                    sprite = entity.__tile and {
                        x = entity.__tile.x, y = entity.__tile.y,
                        w = entity.__tile.w, h = entity.__tile.h
                    } or nil,

                    size = {
                        x = entity.width, y = entity.height
                    },

                    position = {
                        x = entity.px[1], 
                        y = entity.px[2]
                    },
                    
                    visibility = {
                        x = -offset.x, 
                        y = -offset.y,
                        w = tw,
                        h = th
                    },

                    offset = offset
                })
            end

        end
    end
--end

local f = assert(io.open(filename:sub(1, #filename-5)..".json", "w+"), "OUTPUT FILE COULD NOT BE OPENED.")
f:write(json.encode(out_level))
f:close()