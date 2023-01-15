local json = require "json"

local filename = assert(arg[1], "NO FILENAME GIVEN.")

local f = assert(io.open(filename, "r"), "FILE DOES NOT EXIST.")
local map = json.decode(f:read("*all"))
f:close()

local out_map = {}
for _, level in ipairs(map.levels) do
    local out_level = {
        width = level.pxWid,
        height = level.pxHei,
        uid = level.uid,
        tiles = {},
        entities = {}
    }
    table.insert(out_map, out_level)

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
            for uid, entity in ipairs(layer.entityInstances) do
                local fields = {}
                for _, v in ipairs(entity.fieldInstances) do
                    local a = v.__value
                    if v.__type == "Tile" then
                        goto continue
                    end

                    if v.__identifier == "collider" then
                        fields.collider = {
                            x=0, y=0, 
                            w=entity.width,
                            h=entity.height
                        }

                        goto continue
                    end
                    
                    fields[v.__identifier] = a
                    ::continue::
                end

                fields.sprite = entity.__tile and {
                    origin = {
                        x = entity.__tile.x, y = entity.__tile.y,
                        w = entity.__tile.w, h = entity.__tile.h
                    },
                }

                fields.position = {
                    x = entity.px[1],
                    y = entity.px[2]
                }

                table.insert(out_level.entities, fields)
            end

        end
    end
end

local f = assert(io.open(filename:sub(1, #filename-5)..".json", "w+"), "OUTPUT FILE COULD NOT BE OPENED.")
f:write(json.encode(out_map))
f:close()