/obj/machinery/door/airlock/angled_tgmc
	dir = 2
	anim_length_before_finalize = 3
	icon = 'icons/obj/doors/angled/tgmc/generic.dmi'

/obj/machinery/door/airlock/angled_tgmc/cell
	icon = 'icons/obj/doors/angled/tgmc/celldoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/command
	icon = 'icons/obj/doors/angled/tgmc/comdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/dropship1_pilot
	icon = 'icons/obj/doors/angled/tgmc/dropship1_pilot.dmi'
/obj/machinery/door/airlock/angled_tgmc/dropship2_pilot
	icon = 'icons/obj/doors/angled/tgmc/dropship2_pilot.dmi'
/obj/machinery/door/airlock/angled_tgmc/engineering
	icon = 'icons/obj/doors/angled/tgmc/engidoor.dmi'
	glass = TRUE
	opacity = FALSE
/obj/machinery/door/airlock/angled_tgmc/maintenance
	icon = 'icons/obj/doors/angled/tgmc/maintdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/medical
	icon = 'icons/obj/doors/angled/tgmc/medidoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/medical_glass
	icon = 'icons/obj/doors/angled/tgmc/medidoor_glass.dmi'
	glass = TRUE
	opacity = FALSE
/obj/machinery/door/airlock/angled_tgmc/personal
	icon = 'icons/obj/doors/angled/tgmc/personaldoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/pod
	icon = 'icons/obj/doors/angled/tgmc/pod_doors.dmi'
/obj/machinery/door/airlock/angled_tgmc/prep
	icon = 'icons/obj/doors/angled/tgmc/prepdoor.dmi'
	glass = TRUE
	opacity = FALSE
/obj/machinery/door/airlock/angled_tgmc/prep/prep_alpha
	icon = 'icons/obj/doors/angled/tgmc/prepdoor_alpha.dmi'
/obj/machinery/door/airlock/angled_tgmc/prep/prep_bravo
	icon = 'icons/obj/doors/angled/tgmc/prepdoor_bravo.dmi'
/obj/machinery/door/airlock/angled_tgmc/prep/prep_charlie
	icon = 'icons/obj/doors/angled/tgmc/prepdoor_charlie.dmi'
/obj/machinery/door/airlock/angled_tgmc/prep/prep_delta
	icon = 'icons/obj/doors/angled/tgmc/prepdoor_delta.dmi'

/obj/machinery/door/airlock/angled_tgmc/security
	icon = 'icons/obj/doors/angled/tgmc/secdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/security_glass
	icon = 'icons/obj/doors/angled/tgmc/secdoor_glass.dmi'
	glass = TRUE
	opacity = FALSE
/obj/machinery/door/airlock/angled_tgmc/secure
	icon = 'icons/obj/doors/angled/tgmc/securedoor.dmi'


// firedoor
/* /obj/machinery/door/airlock/angled_tgmc/
	icon = 'icons/obj/doors/angled/tgmc/purinadoor.dmi' */
// blastdoor
/* /obj/machinery/door/airlock/angled_tgmc/
	icon = 'icons/obj/doors/angled/tgmc/blastdoors_shutters.dmi' */

/obj/machinery/door/airlock/angled_tgmc/wide
	width = 2
	appearance_flags = 0
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/angled_tgmc/wide/Initialize(mapload)
	. = ..()
	SetBounds()
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/airlock/angled_tgmc/wide/set_opacity()
	. = ..()
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/airlock/angled_tgmc/wide/Moved()
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/angled_tgmc/wide/proc/apply_opacity_to_my_turfs(new_opacity)
	for(var/turf/T in locs)
		T.set_opacity(new_opacity)
	update_nearby_tiles()

/obj/machinery/door/airlock/angled_tgmc/wide/proc/SetBounds()
	if(dir & 3)
		bound_width = world.icon_size
		bound_height = width * world.icon_size
	else
		bound_width = width * world.icon_size
		bound_height = world.icon_size

/obj/machinery/door/airlock/angled_tgmc/wide/command
	icon = 'icons/obj/doors/angled/tgmc/2x1comdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/generic
	icon = 'icons/obj/doors/angled/tgmc/2x1generic.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/generic_steel
	icon = 'icons/obj/doors/angled/tgmc/2x1generic_steel.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/medical
	icon = 'icons/obj/doors/angled/tgmc/2x1medidoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/security
	icon = 'icons/obj/doors/angled/tgmc/2x1secdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/dropship1
	width = 3
	anim_length_before_finalize = 5
	icon = 'icons/obj/doors/angled/tgmc/dropship1_cargo.dmi'
	glass = FALSE
	opacity = TRUE
/obj/machinery/door/airlock/angled_tgmc/wide/dropship2
	width = 3
	anim_length_before_finalize = 5
	icon = 'icons/obj/doors/angled/tgmc/dropship2_cargo.dmi'
	glass = FALSE
	opacity = TRUE

/obj/machinery/door/blast/angled
	icon = 'icons/obj/doors/angled/tgmc/blastdoors_shutters.dmi'
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 600

/obj/machinery/door/blast/angled/open
	icon_state = "pdoor0"
	density = FALSE
	opacity = 0

/obj/machinery/door/blast/angled_shutter
	icon = 'icons/obj/doors/angled/tgmc/blastdoors_shutters.dmi'
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"
	maxhealth = 600

/obj/machinery/door/blast/angled_shutter/open
	icon_state = "shutter0"
	density = FALSE
	opacity = 0
