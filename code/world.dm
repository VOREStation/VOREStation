//Global init and the rest of world's code have been moved to code/global_init.dm and code/game/world.dm respectively.
/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 7
	fps = 20 // If this isnt hard-defined, anything relying on this variable before world load will cry a lot
