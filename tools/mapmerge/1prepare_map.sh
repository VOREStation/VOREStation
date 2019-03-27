#!/bin/sh
cd ../../maps/southern_cross

for f in *.dmm;
do cp $f $f.backup;
done
