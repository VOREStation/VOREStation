//This file is just for the necessary /world definition
//Try looking in /code/game/world.dm, where initialization order is defined

/**
 * # World
 *
 * Two possibilities exist: either we are alone in the Universe or we are not. Both are equally terrifying. ~ Arthur C. Clarke
 *
 * The byond world object stores some basic byond level config, and has a few hub specific procs for managing hub visiblity
 */
/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "VOREStation" //VOREStation Edit
	visibility = 0 //VOREStation Edit
	cache_lifespan = 7
	fps = 20 // If this isnt hard-defined, anything relying on this variable before world load will cry a lot
