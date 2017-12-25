/*
	This file will explain what a 'submap' is.  Basically, they are smallish maps which are loaded on top of
the main map, using the dmm suite's map loading functionality.  Generally this will be done by the game
automatically to sprinkle the play area with hidden buildings and treasure, baddies, or something along
those lines.  Admins can also manually place these down where-ever and whenever they want, potentially
loading it into a new Z-level, for events and such.

	Submaps have two parts, the map .dmm file itself, and a /datum/map_template object which describes the map.
Both should be included inside the correct places.  Submaps are divided based on where the game expects to place
them, and the folder containing them also has their map template file.  The divisions are mainly based around
thematic and location differences (e.g. space, caves, outdoors, asteroid, etc).

	When a submap is loading, the game will 'lock' certain parts of itself, disallowing the loading of a second map until the first
finishes.  When this is happening, atmospherics is also disabled, to prevent ZAS from displacing things and
venting unfinished rooms.  There is some noticable lag if the loading takes awhile, but it remains playable
and it doesn't lock up the came entirely.  Small submaps should load in less than a second, while loading, say, polaris3.dmm
generally takes the server a minute or two, so try to not make your submap too large if possible.

	You can use /area/template_noop and /turf/template_noop to act as 'void' areas/tiles, which won't be applied to the
main map.

	Map template datums can have the 'annihilate' var set to TRUE if you need to clear everything where the submap
is being loaded (to clear trees, etc).  Be sure to not load the map on top of anything valuable to you when using that, like
irreplacable objects or players, as they will all get deleted if annihilate is on.  If you load the submap before
other objects have a chance to spawn (before random map gen), you shouldn't need to use annihilate.

	When adding a new submap which will be loaded at runtime, you should add it to the list of '#include'-s on the top of the
map template file. This forces the submap to be compiled when the code is undergoing a unit test, which will help keep the
submap from suffering errors such as invalid paths due to them being changed elsewhere.

*/