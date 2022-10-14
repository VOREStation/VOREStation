/obj/machinery/button
	name = "button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	layer = ABOVE_WINDOW_LAYER
	desc = "A remote control switch for something."
	var/id = null
	var/active = 0
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	required_dexterity = MOB_DEXTERITY_SIMPLE_MACHINES

/obj/machinery/button/attack_ai(mob/user)
	return attack_hand(user)

<<<<<<< HEAD
/obj/machinery/button/attackby(obj/item/weapon/W, mob/user as mob)
=======
/obj/machinery/button/attackby(obj/item/item, mob/user)
>>>>>>> 9a1b8322bdc... trained drakes can collect/drop items and use buttons, fire alarms, and levers (#8734)
	return attack_hand(user)
