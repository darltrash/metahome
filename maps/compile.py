import json
import msgpack
import sys
import os

# I HATE PYTHON SO FUCKING MUCH
# WHY IS EVERYTHING SO ABSTRACTED AND WEIRD?!

with open(sys.argv[1], "rb") as input:
    data = json.loads(input.read())

output = []
for level in data["levels"]:
    _level = {
        "tiles": []
    }
    collisionHash = {}
    tiles = []

    for layer in level["layerInstances"]:
        if layer["__type"] == "IntGrid":
            for intgrid in layer["intGrid"]:
                collisionHash[intgrid["coordId"]] = True
        elif layer["__type"] == "Tiles":
            for tile in layer["gridTiles"]:
                tiles.append(tile)

    for tile in tiles:
        _tile = {}
        _tile["x"] = tile["px"][0]
        _tile["y"] = tile["px"][1]

        _tile["c"] = collisionHash.get(tile["px"][0]+tile["px"][1], False)

        _tile["sx"] = tile["src"][0]
        _tile["sy"] = tile["src"][1]

        _level["tiles"].append(_tile)

    output.append(_level)

with open(os.path.splitext(sys.argv[1])[0]+".metahome.map", "wb") as out:
    out.write(msgpack.packb(output))

