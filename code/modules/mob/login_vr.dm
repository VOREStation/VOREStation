/mob/Login()
	. = ..()

	if(viewing_alternate_appearances && viewing_alternate_appearances.len)
		for(var/datum/alternate_appearance/AA in viewing_alternate_appearances)
			AA.display_to(list(src))

	var/obj/screen/plane_master/augmented/aug = plane_holder.plane_masters[VIS_AUGMENTED]
	aug.apply()
