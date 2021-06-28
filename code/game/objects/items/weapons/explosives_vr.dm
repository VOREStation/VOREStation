/obj/item/weapon/plastique/seismic/locked
	desc = "Used to dig holes in specific areas without too much extra hole. Has extra mechanism that safely implodes the bomb if it is used in close proximity to the facility."

/obj/item/weapon/plastique/seismic/locked/explode(var/location)
	if(!target)
		target = get_atom_on_turf(src)
	if(!target)
		target = src

	var/turf/T = get_turf(target)
	if(T.z in using_map.station_levels)
		target.visible_message("<span class='danger'>\The [src] lets out a loud beep as safeties trigger, before imploding and falling apart.</span>")
		target.cut_overlay(image_overlay, TRUE)
		qdel(src)
		return 0
	else
		return ..()