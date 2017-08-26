/mob/living/death()
	clear_fullscreens()
	//VOREStation Edit - Mob spawner stuff
	if(source_spawner)
		source_spawner.get_death_report(src)
		source_spawner = null
	//VOREStation Edit End
	. = ..()