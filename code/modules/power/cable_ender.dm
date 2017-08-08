//
// Super Duper Ender Cable - Luckily these are not constructable!
//

//if powernetless_only = 1, will only get connections without powernet
/obj/structure/cable/ender
	// Pretend to be heavy duty power cable
	icon = 'icons/obj/power_cond_heavy.dmi'
	name = "large power cable"
	desc = "This cable is tough. It cannot be cut with simple hand tools."
	layer = 2.39 //Just below pipes, which are at 2.4
	color = null
	unacidable = 1
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
	if(istype(W, /obj/item/weapon/wirecutters))
		usr << "<font color='blue'>These cables are too tough to be cut with those [W.name].</font>"
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		usr << "<font color='blue'>You will need heavier cables to connect to these.</font>"
		return
	else
		..()

// Because they cannot be rebuilt, they are hard to destroy
/obj/structure/cable/ender/ex_act(severity)
	return

