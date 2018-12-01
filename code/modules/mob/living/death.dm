/mob/living/death()
	clear_fullscreens()
<<<<<<< HEAD
	reveal(TRUE) //Silently reveal the mob if they were hidden.
	//VOREStation Edit - Mob spawner stuff
	if(source_spawner)
		source_spawner.get_death_report(src)
		source_spawner = null
	//VOREStation Edit End
	. = ..()
=======

	if(ai_holder)
		ai_holder.go_sleep()
>>>>>>> 3155d58... Merge pull request #5735 from Neerti/hopefully_last_master_sync

	if(nest) //Ew.
		if(istype(nest, /obj/structure/prop/nest))
			var/obj/structure/prop/nest/N = nest
			N.remove_creature(src)
		if(istype(nest, /obj/structure/blob/factory))
			var/obj/structure/blob/factory/F = nest
			F.spores -= src
		nest = null
	. = ..()
