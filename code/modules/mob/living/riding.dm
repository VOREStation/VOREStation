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
<<<<<<< HEAD
				riding_datum.keytype = /obj/item/weapon/material/twohanded/riding_crop
				to_chat(src, "Rider control restricted.")
=======
				riding_datum.keytype = /obj/item/material/twohanded/riding_crop
				to_chat(src, "<span class='filter_notice'>Rider control restricted.</span>")
>>>>>>> 75577bd3ca9... cleans up so many to_chats so they use vchat filters, unsorted chat filter for everything else (#9006)
				return
	return
