/datum/element/cleaning/Attach(datum/target)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(Clean))

/datum/element/cleaning/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)

/datum/element/cleaning/proc/Clean(datum/source)
	SIGNAL_HANDLER
	var/atom/movable/AM = source
	var/turf/tile = AM.loc
	if(!isturf(tile))
		return

	tile.wash(CLEAN_WASH)
	for(var/A in tile)
		// Clean small items that are lying on the ground
		if(isitem(A))
			var/obj/item/I = A
			if(I.w_class <= ITEMSIZE_SMALL && !ismob(I.loc))
				I.wash(CLEAN_WASH)
		// Clean humans that are lying down
		else if(ishuman(A))
			var/mob/living/carbon/human/cleaned_human = A
			if(cleaned_human.lying)
				cleaned_human.wash(CLEAN_WASH)
				to_chat(cleaned_human, span_danger("[AM] cleans your face!"))
