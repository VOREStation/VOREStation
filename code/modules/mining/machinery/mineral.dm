/obj/machinery/mineral
	name = DEVELOPER_WARNING_NAME
	desc = DEVELOPER_WARNING_NAME
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace_old"
	var/static/connection_range = 5
	var/sets_direction = FALSE // We don't want to set the direction of consoles
	var/output_dir = 0 // direction that we output material

/obj/machinery/mineral/Initialize(mapload)
	. = ..()
	GLOB.mineral_machines += src

/obj/machinery/mineral/Destroy()
	GLOB.mineral_machines -= src
	. = ..()

/obj/machinery/mineral/proc/has_link()
	return FALSE

/obj/machinery/mineral/proc/find_nearest_linkable(filtering_type)
	var/nearest_distance = INFINITY
	var/nearest_machine = null
	for(var/obj/machinery/mineral/checking in GLOB.mineral_machines)
		if(!istype(checking, filtering_type))
			continue
		if(checking.has_link())
			continue
		var/turf/A = get_turf(src)
		var/turf/B = get_turf(checking)
		var/distcheck = A.Distance(B)
		if(distcheck > connection_range)
			continue
		if(distcheck >= nearest_distance)
			continue
		nearest_distance = distcheck
		nearest_machine = checking
	return nearest_machine

/obj/machinery/mineral/examine(mob/user, infix, suffix)
	. = ..()
	if(!sets_direction)
		return
	if(output_dir)
		. += span_notice("Currently configured to intake material from the <b>[dir2text(reverse_direction(output_dir))]</b> and drop processed material <b>[dir2text(output_dir)]</b>.")
		. += span_notice("Alt-click to reset.")
	else
		. += span_notice("Drag towards a direction (while next to it) to change drop direction.")

/obj/machinery/mineral/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	if(!sets_direction)
		return ..()
	var/mob/user = usr
	if(!Adjacent(user))
		return
	if(isobserver(user) || user.is_incorporeal())
		return
	var/direction = get_dir(src, over_location)
	if(!direction)
		return
	output_dir = direction
	balloon_alert(user, "dropping [dir2text(output_dir)]")

/obj/machinery/mineral/click_alt(mob/user)
	if(!sets_direction)
		return ..()
	if(!output_dir)
		return CLICK_ACTION_BLOCKING
	balloon_alert(user, "drop direction reset")
	output_dir = 0
	return CLICK_ACTION_SUCCESS
