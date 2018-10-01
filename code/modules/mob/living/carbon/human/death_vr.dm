/mob/living/carbon/human/gib()
	
	//Drop the NIF, they're expensive, why not recover them? Also important for prometheans.
	if(nif)
		var/obj/item/device/nif/deadnif = nif //Unimplant removes the reference on the mob
		deadnif.unimplant(src)
		deadnif.forceMove(drop_location())
		deadnif.throw_at(get_edge_target_turf(src,pick(alldirs)), rand(1,3), round(30/deadnif.w_class))
		deadnif.wear(10) //Presumably it's gone through some shit if they got gibbed?
	
	. = ..()
