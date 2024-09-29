/mob/living/proc/toggle_rider_reins()
	set name = "Give Reins"
	set category = "Abilities"
	set desc = "Let people riding on you control your movement."

	if(riding_datum)
		if(istype(riding_datum,/datum/riding))
			if(riding_datum.keytype)
				riding_datum.keytype = null
				to_chat(src, "<span class='filter_notice'>Rider control enabled.</span>")
				return
			else
				riding_datum.keytype = /obj/item/material/twohanded/riding_crop
				to_chat(src, "<span class='filter_notice'>Rider control restricted.</span>")
				return
	return
