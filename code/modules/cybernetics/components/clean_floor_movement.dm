/datum/component/clean_floor
	var/active = TRUE
	var/check_if_standing = TRUE //ignored for non humans
	var/tier = 0 //0 = clean, 1 = mop, 2 = lube. Why not?

	var/chance //out of 100, if 0 or more than 100 it's 100% of the time

/datum/component/clean_floor/Initialize(...)
	. = ..()
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_OBSERVER_MOVED, PROC_REF(check_loc))

/datum/component/clean_floor/Destroy(force)
	if(parent)
		UnregisterSignal(parent,COMSIG_OBSERVER_MOVED)
	. = ..()


/datum/component/clean_floor/proc/check_loc(var/atom/source, var/atom/old_loc, var/atom/new_loc)
	if(!active) return
	if(!isturf(new_loc)) return
	var/turf/tile = new_loc
	if(check_if_standing)
		if(ishuman(parent))
			var/mob/living/carbon/human/stander = parent
			if(stander.lying) return

	if(chance)
		if(!prob(chance)) return

	tile.wash(CLEAN_SCRUB)


	if (istype(tile, /turf/simulated))
		var/turf/simulated/S = tile
		S.dirt = 0
		if(tier > 0)
			S.wet_floor(tier)

	for(var/atom/A in tile)
		if(istype(A, /obj/effect))
			if(istype(A, /obj/effect/rune) || istype(A, /obj/effect/decal/cleanable) || istype(A, /obj/effect/overlay))
				qdel(A)
		else if(istype(A, /obj/item))
			var/obj/item/cleaned_item = A
			cleaned_item.wash(CLEAN_SCRUB)
		else if(ishuman(A))
			var/mob/living/carbon/human/cleaned_human = A
			if(cleaned_human.lying)
				if(cleaned_human.head)
					cleaned_human.head.wash(CLEAN_SCRUB)
					cleaned_human.update_inv_head(0)
				if(cleaned_human.wear_suit)
					cleaned_human.wear_suit.wash(CLEAN_SCRUB)
					cleaned_human.update_inv_wear_suit(0)
				else if(cleaned_human.w_uniform)
					cleaned_human.w_uniform.wash(CLEAN_SCRUB)
					cleaned_human.update_inv_w_uniform(0)
				if(cleaned_human.shoes)
					cleaned_human.shoes.wash(CLEAN_SCRUB)
					cleaned_human.update_inv_shoes(0)
				cleaned_human.wash(CLEAN_SCRUB)
				to_chat(cleaned_human, span_warning("[parent] cleans your face!"))
