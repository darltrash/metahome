#!/bin/sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR
cd ldtk_conversor

for i in ../*.ldtk; do
    [ -f "$i" ] || break
    lua main.lua $i
done
