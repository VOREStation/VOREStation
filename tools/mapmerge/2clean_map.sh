#!/bin/sh
for f in ../../maps/southern_cross/*.dmm;
do java -jar MapPatcher.jar -clean $f.backup $f $f;
done
