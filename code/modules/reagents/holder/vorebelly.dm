/datum/reagents/proc/vore_trans_to_mob(var/mob/target, var/amount = 1, var/type = CHEM_VORE, var/multiplier = 1, var/copy = 0, var/obj/belly/target_belly = null) // Transfer after checking into which holder...
	if(!target || !istype(target))
		return

	if(isliving(target))
		if(type == CHEM_VORE)
			var/datum/reagents/R = target_belly.reagents
			if(!R)
				R = new /datum/reagents(amount)
				target_belly.reagents = R
			return trans_to_holder(R, amount, multiplier, copy)
		if(type == CHEM_INGEST && iscarbon(target))
			var/mob/living/carbon/C = target
			var/datum/reagents/R = C.ingested
			return C.ingest(src, R, amount, multiplier, copy)

	else //Retaining this code as a backup
		var/datum/reagents/R = new /datum/reagents(amount)
		. = trans_to_holder(R, amount, multiplier, copy)
		R.touch_mob(target)

/datum/reagents/proc/vore_trans_to_con(var/obj/item/reagent_containers/T, var/amount = 1, var/multiplier = 1, var/copy = 0) // Transfer after checking into which holder...
	if(!T || !istype(T))
		return

	return trans_to_holder(T.reagents, amount, multiplier, copy)
