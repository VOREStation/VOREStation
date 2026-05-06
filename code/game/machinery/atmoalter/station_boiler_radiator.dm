/obj/machinery/stationboiler_radiator
	name = "Station Radiator"
	desc = "A radiator pipe connected to the station boiler, used to keep the rooms warm"
	icon = 'icons/obj/machines/floor_radiator.dmi'

	plane = PLATING_PLANE
	layer = FLOOR_HEATER_LAYER

	icon_state = "off"
	use_power = USE_POWER_OFF
	bullet_vulnerability = 0 //Invincible machine
	anchored = TRUE
	density = FALSE
	var/actively_radiating = FALSE

/obj/machinery/stationboiler_radiator/Initialize(mapload)
	. = ..()
	SSstationheater.radiators += src

/obj/machinery/stationboiler_radiator/Destroy()
	SSstationheater.radiators -= src
	. = ..()

/obj/machinery/stationboiler_radiator/update_icon()
	icon_state = actively_radiating ? "on" : "off"

/obj/machinery/stationboiler_radiator/ex_act(severity)
	return //Invincible machine

/obj/machinery/atmospherics/binary/stationboiler/fall_apart(severity = 3, scatter = TRUE)
	return //Invincible machine
