#!/bin/bash
rm metahome

set -e
echo "It's building and packing time!"
zig build install -Drelease-fast=true

echo "> Creating a file for our fantastic hacker friends :)"

echo "
>	Hello fellow hacker/dataminer! How's everything? :D
>	Just wanted to tell you that this game is OPEN SOURCE, 
>	you DONT NEED to decompile it or something, just get the source lmao.
>
>	Btw, Have a great time inspecting the source, i spent a lot of time on it.
" > FELLOWHACKAHZ.txt
# Hello everyone, Send love to y'all! :)

echo "> Compressing the stuff up"

zip     DATA.zip FELLOWHACKAHZ.txt          -0
zip -ur DATA.zip sprites                    -0
zip -ur DATA.zip maps -x "*.ldtk" -x "*.py" -0
cat zig-cache/bin/metahome DATA.zip > metahome

echo "> Cleaning the horrible mess that just happened"

rm FELLOWHACKAHZ.txt
rm DATA.zip

chmod +x metahome
echo "And done! Have fun!"
