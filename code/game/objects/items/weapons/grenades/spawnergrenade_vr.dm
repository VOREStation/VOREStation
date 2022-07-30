/obj/item/grenade/spawnergrenade/manhacks/station/locked
	desc = "It is set to detonate in 5 seconds. It will deploy three weaponized survey drones. This one has a safety interlock that prevents release if used while in proximity to the facility."
	req_access = list(access_armory) //for toggling safety
	var/locked = 1

/obj/item/grenade/spawnergrenade/manhacks/station/locked/detonate()
	if(locked)
		var/turf/T = get_turf(src)
		if(T.z in using_map.station_levels)
			icon_state = initial(icon_state)
			active = 0
			return 0
	return ..()

/obj/item/grenade/spawnergrenade/manhacks/station/locked/attackby(obj/item/I, mob/user)
	var/obj/item/card/id/id = I.GetID()
	if(istype(id))
		if(check_access(id))
			locked = !locked
			to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		user.visible_message("<span class='notice'>[user] swipes \the [I] against \the [src].</span>")
	else
		return ..()

/obj/item/grenade/spawnergrenade/manhacks/station/locked/emag_act(var/remaining_charges,var/mob/user)
	..()
	locked = !locked
	to_chat(user, "<span class='warning'>You [locked ? "enable" : "disable"] the safety lock on \the [src]!</span>")
