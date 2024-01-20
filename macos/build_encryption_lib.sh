#!/bin/bash
#cd encryptionLib
#mkdir -p build
#cd build
#cmake ..
#make

# Pfad zur C-Library relativ zum Skript-Verzeichnis
LIBRARY_PATH="../encryptionLib/"

# Kompilieren der C-Library
cd "$LIBRARY_PATH"
mkdir -p "$LIBRARY_PATH/build"
cd build
cmake ..
make

# Kopieren der .dylib in das Frameworks-Verzeichnis
cp -f libencryptionLib.dylib "$SRCROOT/Flutter/ephemeral/.symlinks/plugins/"