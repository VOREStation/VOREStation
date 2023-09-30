//
// Super Duper Ender Cable - Luckily these are not constructable!
//

//if powernetless_only = 1, will only get connections without powernet
/obj/structure/cable/ender
	// Pretend to be heavy duty power cable
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	plane = PLATING_PLANE
	layer = PIPES_LAYER - 0.05 //Just below pipes
	color = null
	unacidable = TRUE
	var/id = null

/obj/structure/cable/ender/get_connections(var/powernetless_only = 0)
	. = ..() // Do the normal stuff
	if(id)
		for(var/obj/structure/cable/ender/target in cable_list)
			if(target.id == id)
				if (!powernetless_only || !target.powernet)
					. |= target

/obj/structure/cable/ender/attackby(obj/item/W, mob/user)
	src.add_fingerprint(user)
	if(W.has_tool_quality(TOOL_WIRECUTTER))
		to_chat(user,  "<span class='notice'> These cables are too tough to be cut with those [W.name].</span>")
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		to_chat(user,  "<span class='notice'> You will need heavier cables to connect to these.</span>")
		return
	else
		..()

// Because they cannot be rebuilt, they are hard to destroy
/obj/structure/cable/ender/ex_act(severity)
	return

