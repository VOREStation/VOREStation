/obj/machinery/button
	name = "button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
//	plane = TURF_PLANE //Can't have them under tables, oh well.
//	layer = ABOVE_TURF_LAYER
	desc = "A remote control switch for something."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4

/obj/machinery/button/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/button/attackby(obj/item/weapon/W, mob/user as mob)
	return attack_hand(user)

// VOREStation Edit Begin
/obj/machinery/button/attack_hand(obj/item/weapon/W, mob/user as mob)
	if(..()) return 1
	playsound(loc, 'sound/machines/button.ogg', 100, 1)
// VOREStation Edit End
