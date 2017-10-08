/*
This system is in place to make it easier to seperate data specific to a certain map.

Each map should have their own folder, and contain both the actual map files, and the code files defining their unique
things, such as areas, elevators, or shuttles.  Generally, the layout is that your map folder has,

[map_name] folder
	[map_name].dm - Containing a lot of #define directives, and is used to automatically load the other files you need.
	[map_name_defines].dm - This contains the code for the map datum.  For more details, read the comments inside ~map_system folder.
	(optional) [map_name]_areas/structures/whatever.dm - Files for unique things to that map.
	[map_name]-1.dmm - Your actual map files.  Z-levels should be ordered correctly if you seperate your z-levels across map files.

-HOW TO LOAD A SPECIFIC MAP-
Say you want to load southern_cross,
First, uncheck your current loaded map, presumably northern_star.  Uncheck northern_star.dm inside northern_star folder.
Then go open southern_cross folder, and check southern_cross.dm, don't check any other folders below, and compile.
When you finish compiling, you should be able to open the map files for southern_cross.
*/