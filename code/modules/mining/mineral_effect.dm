/obj/effect/mineral
	name = "mineral vein"
	icon = 'icons/obj/mining.dmi'
	desc = "Shiny."
	mouse_opacity = 0
	density = FALSE
	anchored = TRUE
	var/ore_key
	var/image/scanner_image
	var/ore_reagent	// Reagent from pumping water near this ore.

/obj/effect/mineral/Initialize(mapload)
	. = ..()
	var/turf/simulated/mineral/min_turf = loc
	if(!istype(min_turf))
		return INITIALIZE_HINT_QDEL
	var/ore/M = min_turf.mineral
	name = "[M.display_name] deposit"
	ore_key = M.name
	if(M.reagent)
		ore_reagent = M.reagent
	icon_state = "rock_[ore_key]"
	layer = min_turf.layer+0.1

/obj/effect/mineral/proc/get_scan_overlay()
	if(!scanner_image)
		var/ore/O = GLOB.ore_data[ore_key]
		if(O)
			scanner_image = image(icon, loc = get_turf(src), icon_state = (O.scan_icon ? O.scan_icon : icon_state))
		else
			to_world("No ore data for [src]!")
	return scanner_image
