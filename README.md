# m e t a h o m e
```
an experimental game about experimentation in games, a journey into my mind.

this game is still nothing but a tech demo right now, but the engine currently supports:
  - tile-based maps encoded with MSGPACK (and a LDTK to MSGPACK map conversor)
  - tile-based rendering of tiles in a tileset
  - tileset loading and overall (limited) filesystem abilities
  - basic font rendering (thanks sokol)

things i need to add:
  - audio thingies
  - tracker music format support
  - entity handler
  - dialog handler
  - KOOL SHADURZ (VERY COOL)
  - packing every single asset onto the binary itself (hard)

things i may add:
  - GLES2 support (and thus, also native wayland support)
  - gamepad support
  - a level editor made in GTK4 (ooor imgui, that is also a posibility)


HOW TO RUN:
  you will need: 
    - the xorg development libraries 
    - preferabily a GL3+ compatible GPU
    - zig master 0.8.0
    - a little bit of patience
  
  first clone this repo, then build it with "zig build run"
  and that should be it, really.
  
  If it shows up some weird error message like "hEY FAiLeD to INitIalizE Gl cOntEXt XD"
  then, you may need to try this out in a newer GPU or use ./run.sh and sacrifice performance.
  
  note: I have no idea of the outcome of this program or anything related to it and i am not responsible for that.
  i havent tested it on macOS nor Windows, so if you do, please leave me an issue or something :)
  
LICENSE:
  Copyright (c) Nelson "darltrash" Lopez
  Check LICENSE and ASSETSLICENSE.
```
