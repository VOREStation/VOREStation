/mob/living/death()
	clear_fullscreens()
<<<<<<< HEAD
	//VOREStation Edit - Mob spawner stuff
	if(source_spawner)
		source_spawner.get_death_report(src)
		source_spawner = null
	//VOREStation Edit End
	. = ..()
=======

	if(ai_holder)
		ai_holder.go_sleep()

	if(nest) //Ew.
		if(istype(nest, /obj/structure/prop/nest))
			var/obj/structure/prop/nest/N = nest
			N.remove_creature(src)
		if(istype(nest, /obj/structure/blob/factory))
			var/obj/structure/blob/factory/F = nest
			F.spores -= src
		nest = null
	. = ..()
>>>>>>> f98e9bf... Updates AI branch to Master (#5591)
