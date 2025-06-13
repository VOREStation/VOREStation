/datum/element/cleaning

/datum/element/cleaning/Attach(datum/target)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(clean))

/datum/element/cleaning/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/datum/element/cleaning/proc/clean(datum/source)
	SIGNAL_HANDLER

	var/atom/movable/AM = source
	var/turf/tile = AM.loc
	if(!isturf(tile))
		return

	tile.wash(CLEAN_WASH)

	for(var/atom/cleaned as anything in tile)
		if(isitem(cleaned))
			var/obj/item/cleaned_item = cleaned
			if(cleaned_item.w_class <= ITEMSIZE_SMALL)
				cleaned_item.wash(CLEAN_SCRUB)
			continue
		if(istype(cleaned, /obj/effect/decal/cleanable))
			var/obj/effect/decal/cleanable/cleaned_decal = cleaned
			cleaned_decal.wash(CLEAN_SCRUB)
		if(!ishuman(cleaned))
			continue
		var/mob/living/carbon/human/cleaned_human = cleaned
		if(cleaned_human.lying)
			cleaned_human.wash(CLEAN_SCRUB)
			to_chat(cleaned_human, span_danger("[AM] washes your face!"))
