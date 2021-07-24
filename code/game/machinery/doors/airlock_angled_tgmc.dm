/obj/machinery/door/airlock/angled_tgmc
	dir = 2
	anim_length_before_finalize = 3

/obj/machinery/door/airlock/angled_tgmc/cell
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/celldoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/command
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/comdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/dropship1_pilot
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/dropship1_pilot.dmi'
/obj/machinery/door/airlock/angled_tgmc/dropship2_pilot
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/dropship2_pilot.dmi'
/obj/machinery/door/airlock/angled_tgmc/engineering
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/engidoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/maintenance
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/maintdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/medical
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/medidoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/medical_glass
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/medidoor_glass.dmi'
	glass = TRUE
	opacity = FALSE
/obj/machinery/door/airlock/angled_tgmc/personal
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/personaldoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/pod
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/pod_doors.dmi'
/obj/machinery/door/airlock/angled_tgmc/prep
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/prepdoor.dmi'
	glass = TRUE
	opacity = FALSE
/obj/machinery/door/airlock/angled_tgmc/prep/prep_alpha
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/prepdoor_alpha.dmi'
/obj/machinery/door/airlock/angled_tgmc/prep/prep_bravo
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/prepdoor_bravo.dmi'
/obj/machinery/door/airlock/angled_tgmc/prep/prep_charlie
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/prepdoor_charlie.dmi'
/obj/machinery/door/airlock/angled_tgmc/prep/prep_delta
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/prepdoor_delta.dmi'

/obj/machinery/door/airlock/angled_tgmc/security
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/secdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/security_glass
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/secdoor_glass.dmi'
	glass = TRUE
	opacity = FALSE
/obj/machinery/door/airlock/angled_tgmc/secure
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/securedoor.dmi'


// firedoor
/* /obj/machinery/door/airlock/angled_tgmc/
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/purinadoor.dmi' */
// blastdoor
/* /obj/machinery/door/airlock/angled_tgmc/
	icon_state = "door_closed"
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
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/2x1comdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/generic
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/2x1generic.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/medical
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/2x1medidoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/security
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/2x1secdoor.dmi'
/obj/machinery/door/airlock/angled_tgmc/wide/dropship1
	width = 3
	anim_length_before_finalize = 5
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/dropship1_cargo.dmi'
	glass = FALSE
	opacity = TRUE
/obj/machinery/door/airlock/angled_tgmc/wide/dropship2
	width = 3
	anim_length_before_finalize = 5
	icon_state = "door_closed"
	icon = 'icons/obj/doors/angled/tgmc/dropship2_cargo.dmi'
	glass = FALSE
	opacity = TRUE