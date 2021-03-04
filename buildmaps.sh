#!/bin/bash

for f in maps/*.ldtk; do 
python3 maps/compile.py $f;
done
