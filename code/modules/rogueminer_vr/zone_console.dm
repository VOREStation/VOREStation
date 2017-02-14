//////////////////////////////
// The zone control console, fluffed ingame as
// a scanner console for the asteroid belt
//////////////////////////////

/obj/machinery/computer/roguezones
	name = "asteroid belt scanning computer"
	desc = "Used to monitor the nearby asteroid belt and detect new areas."
	icon_keyboard = "tech_key"
	icon_screen = "request"
	light_color = "#315ab4"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/weapon/circuitboard/roguezones
	var/datum/nano_module/rogueconsole/nano_rc

/datum/nano_module/rogueconsole
//You should put actual code here for the nanoui thing.

/obj/item/weapon/circuitboard/roguezones
//You should probably actually define this too.