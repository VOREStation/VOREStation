/turf/unsimulated
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/skip_init = TRUE // Don't call down the chain, apparently for performance when loading maps at runtime.
	flags = TURF_ACID_IMMUNE

/turf/unsimulated/Initialize(mapload)
	if(skip_init)
		flags |= ATOM_INITIALIZED
		return INITIALIZE_HINT_NORMAL
	. = ..()

//VOREStation Add
/turf/unsimulated/fake_space
	name = "\proper space"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	dynamic_lighting = FALSE

/turf/unsimulated/fake_space/Initialize(mapload)
	. = ..()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
//VOREStation Add End

// cant wet or slip in space, even fake space.
/turf/unsimulated/fake_space/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return FALSE

/turf/unsimulated/fake_space/MakeDry(wet_setting, immediate, amount)
	return FALSE

/turf/unsimulated/fake_space/handle_slip(mob/living/M, weaken_amount, obj/slipped_on, lube, slip_dist, stun_amount, force_drop)
	return FALSE

// Better nip this just in case.
/turf/unsimulated/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

/turf/unsimulated/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	return FALSE

/turf/unsimulated/occult_act(mob/living/user)
	return FALSE
