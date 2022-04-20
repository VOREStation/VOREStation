/*
	The secret tech system! This is to add some more gameplay to RnD beyond the basic tech speedruns and deconstructing.

	Basically, we setup origin techs on an item and also secret techs, when the item is successfully scanned in a radiocarbon spectrometer (code/modules/xenoarcheaology/tools/geosample_scanner.dm), then it will add secret techs to it's origin tech list.
*/

// Here we set the tech cap, this is the maximum tech that an item can have in it's default origin techs. Any higher and the difference is placed into secret tech.
#define TECH_CAP 4

/obj/item
	var/list/secret_tech = null

// This is the proc for updating tech, calling it will add secret_tech into origin_tech, then set secret_tech to null so that one can't just infinitely increase an item's tech level.
/obj/item/proc/update_techs()
	for(var/I in origin_tech)
		for(var/T in secret_tech)
			if(CallTechName(T) == CallTechName(I))
				origin_tech[I] = secret_tech[T] + origin_tech[I]
				secret_tech.Remove(T)
	origin_tech += secret_tech
	secret_tech = null

// This gives us a hardcap at initialization.
/obj/item/Initialize()
	if(origin_tech && !secret_tech)
		for(var/T in origin_tech)
			if(origin_tech[T] > TECH_CAP)
				secret_tech += (origin_tech[T] - TECH_CAP)
				origin_tech[T] = TECH_CAP

/obj/item/weapon/secret_finder
	name = "Portable Resonant Analyzer"
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_scanner"
	desc = "An advanced scanning device used for analyzing objects potential for destructive analysis."
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_BELT

/obj/item/weapon/secret_finder/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(istype(target,/obj/item))
		var/obj/item/I = target
		playsound(src, 'sound/machines/destructive_analyzer.ogg', 25, 1)
		if(do_after(user, 5 SECONDS))
			for(var/mob/M in viewers())
				M.show_message(text("<span class='notice'>[user] sweeps \the [src] over \the [I].</span>"), 1)
			flick("[initial(icon_state)]-scan", src)
			if(I.origin_tech && I.origin_tech.len)
				for(var/T in I.origin_tech)
					to_chat(user, span_notice("The [I] had level [I.origin_tech[T]] in [CallTechName(T)]."))
			else if(!I.secret_tech)
				to_chat(user, span_notice("No relevant technological advancments detected."))
				playsound(src, 'sound/machines/buzz-sigh.ogg', 25, 1)
				return
			else
				to_chat(user, span_notice("No origin tech detected. Hidden levels possible."))
			playsound(src, 'sound/machines/chime.ogg', 25, 1)
			if(I.secret_tech)
				to_chat(user, span_notice("Hidden technological potential detected! Advanced radiocarbon spectrometer scan recomended!"))