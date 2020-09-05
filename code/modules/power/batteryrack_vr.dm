/obj/item/weapon/module/power_control/attackby(var/obj/item/I, var/mob/user)
	if(I.is_multitool())
		to_chat(user, SPAN_NOTICE("You begin tweaking the power control circuits to support a power cell rack."))
		if(do_after(user, 50 * I.toolspeed))
			var/obj/item/newcircuit = new/obj/item/weapon/circuitboard/batteryrack(get_turf(user))
			qdel(src)
			user.put_in_hands(newcircuit)
			return
	return ..()
