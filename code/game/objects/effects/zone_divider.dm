// This artificially splits a ZAS zone, useful if you wish to prevent massive super-zones which can cause lag.
/obj/effect/zone_divider
	name = "zone divider"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	invisibility = 101 		//nope, can't see this
	anchored = TRUE
	density = FALSE
	opacity = 0
	can_atmos_pass = ATMOS_PASS_PROC

/obj/effect/zone_divider/CanZASPass(turf/T, is_zone)
 	// Special case to prevent us from being part of a zone during the first air master tick.
 	// We must merge ourselves into a zone on next tick.  This will cause a bit of lag on
 	// startup, but it can't really be helped you know?
	if(air_master && air_master.current_cycle == 0)
		spawn(1)
			air_master.mark_for_update(get_turf(src))
		return FALSE
	return is_zone ? FALSE : TRUE // Anything except zones can pass
