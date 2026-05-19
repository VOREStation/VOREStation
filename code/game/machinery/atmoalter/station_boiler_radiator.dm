/// A floor radiator made to work with the station_boiler. If none are on the map then they are purely asthetic and safe to map.
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
	VAR_PRIVATE/actively_radiating = FALSE

/obj/machinery/stationboiler_radiator/Initialize(mapload)
	. = ..()
	SSstationheater.radiators += src

/obj/machinery/stationboiler_radiator/Destroy()
	SSstationheater.radiators -= src
	. = ..()

/obj/machinery/stationboiler_radiator/proc/set_state(activate)
	if(actively_radiating == activate)
		return
	actively_radiating = activate
	update_icon()
	set_light(actively_radiating, 0.9, "#e9400dff")

/obj/machinery/stationboiler_radiator/proc/get_radiating()
	return actively_radiating

/obj/machinery/stationboiler_radiator/update_icon()
	icon_state = actively_radiating ? "on" : "off"

// TODO - Make a viable sane construction method for these
/obj/machinery/stationboiler_radiator/ex_act(severity)
	return //Invincible machine

/obj/machinery/stationboiler_radiator/fall_apart(severity = 3, scatter = TRUE)
	return //Invincible machine
