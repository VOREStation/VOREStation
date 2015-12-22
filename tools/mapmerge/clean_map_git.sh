#!/bin/bash

for i in {1..5}
do
	MAPFILE="polaris-$i.dmm"

	git show HEAD:maps/$MAPFILE > tmp.dmm
	java -jar MapPatcher.jar -clean tmp.dmm '../../maps/'$MAPFILE '../../maps/'$MAPFILE
	rm tmp.dmm
done
