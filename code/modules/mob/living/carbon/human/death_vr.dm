/mob/living/carbon/human/gib()

	//Drop the NIF, they're expensive, why not recover them?
	release_vore_contents(silent = TRUE)
	if(nif)
		var/obj/item/nif/deadnif = nif //Unimplant removes the reference on the mob
		if(!deadnif.gib_nodrop)
			deadnif.unimplant(src)
			deadnif.forceMove(drop_location())
			deadnif.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)), rand(1,3), round(30/deadnif.w_class))
			deadnif.wear(10) //Presumably it's gone through some shit if they got gibbed?

	. = ..()

//For making sure that if a mob is able to be joined by ghosts, that ghosts can't join it if it dies
/mob/living/simple_mob/death()
	..()
	ghostjoin = 0
	GLOB.active_ghost_pods -= src
	ghostjoin_icon()
