/obj/machinery/atmospherics/binary/pump/high_power
	icon = 'icons/atmos/volume_pump.dmi'
	icon_state = "map_off"
	construction_type = /obj/item/pipe/directional
	pipe_state = "volumepump"
	level = 1

	name = "high power gas pump"
	desc = "A pump that moves gas from one place to another. Has double the power rating of the standard gas pump."

	power_rating = 15000	//15000 W ~ 20 HP

/obj/machinery/atmospherics/binary/pump/high_power/on
	use_power = USE_POWER_IDLE
	icon_state = "map_on"

/obj/machinery/atmospherics/binary/pump/high_power/update_icon()
	if(!powered())
		icon_state = "off"
	else
		icon_state = "[use_power ? "on" : "off"]"
