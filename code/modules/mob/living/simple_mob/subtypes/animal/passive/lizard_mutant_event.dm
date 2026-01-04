/mob/living/simple_mob/animal/passive/lizard/event
	desc = "This one looks like it is growing huge!"
	var/amount_grown = 0
	faction = "lizard"

/mob/living/simple_mob/animal/passive/lizard/event/Life()
	. = ..()
	if(amount_grown >= 0)
		amount_grown += rand(0,4)
	if(amount_grown >= 100 && icon_state != icon_dead)
		man()
		return

/mob/living/simple_mob/animal/passive/lizard/event/proc/man()
	var/mob/bigger = new /mob/living/simple_mob/vore/aggressive/lizardman(get_turf(src))

	if(istype(loc,/obj/belly))
		var/obj/belly/B = loc
		B.owner.visible_message(span_boldwarning("Something grows inside [B.owner]'s [lowertext(B.name)]!"))
		to_chat(B.owner, span_warning("\The [src] suddenly evolves inside your [lowertext(B.name)]!"))
		B.release_specific_contents(src, TRUE)
		B.nom_atom(bigger, null)
		qdel(src)
	else
		visible_message(span_warning("\The [src] suddenly evolves!"))
		qdel(src)
