# METAHOME*

![](./banner.png)

An experimental game about experimentation in games, a journey into my mind.
This game is nothing but a tech demo right now, but it's getting there :)

<br>

# REQUIREMENTS:
- ## Linux*:
  - the X11 dev libraries (I am profusely sorry, wayland users)
  - the ALSA dev libraries
  - a GLES2-capable GPU (most are GLES2-capable)
    
- ## MacOS:
  - MacOS core development libraries 
  - a Metal-capable device

- ## Windows:
  - Windows development libraries
  - a DirectX 11 capable system (if you can run Windows 7, you already have this.)

- ## Web:
    Not possible yet, since sokol_app.h and others require special macros and
    libraries from emscripten, which are planned to be integrated into zig, an
    issue was made here: https://github.com/ziglang/zig/issues/10836

- ## All:
  - Zig 0.11.0 
  - a lot of love and patience :)

> NOTE: Linux* refeers to most Linux-like systems out there, which includes systems such as FreeBSD.

<br>

# HOW TO BUILD AND RUN:
- ## BUILD MAPS
  They come precompiled most of the time, so only do this if you have modified the maps in any way.
  
  The maps are done through LDTK and they need a functional Lua5.1+ install and a functional unix-like OS.

  - Clone this repo
  - run "zig build maps"
  - that's it :)

- ## RUN DEBUG:
  - Clone this repo
  - run "zig build run"
  - that's it :)

- ## EXPORT:
  - Clone this repo
  - run "zig build -Drelease-small=true"
  - the binary will be at zig-out/bin/metahome :)

  For cross-compiling, [you can use the "-Dtarget=" flag for Zig](https://ziglang.org/documentation/master/#Targets)

<br>

# DEVELOPMENT PHILOSOPHY:
    I have been struggling with ADHD for a long while and i have wanted to follow a programming philosophy 
    i call "first trashcode, then refine", which means that this code is utter garbage and it's like 
    that in purpose, so before anyone points something like "HEY U HAEV A CODEIGN PORBELM" out,
    consider that this is nothing but a DEMO of what's coming up next (which will also be open source).

    in resume: this code is garbage and i will fix it later, deal with it.
