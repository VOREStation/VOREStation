/obj/machinery/airlock_sensor/co2
	icon = 'icons/obj/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "carbon dioxide sensor"
	var/previousco2

/obj/machinery/airlock_sensor/co2/process()
	if(on)
		var/datum/gas_mixture/air_sample = return_air()
		var/pressure = round(air_sample.return_pressure(), 0.1)
		var/co2 = ("carbon_dioxide" in air_sample.gas) ? round(air_sample.gas["carbon_dioxide"], 0.1) : 0

		if(abs(pressure - previousPressure) > 0.1 || previousPressure == null || abs(co2 - previousco2) > 0.1 || previousco2 == null)
			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO //radio signal
			signal.data["tag"] = id_tag
			signal.data["timestamp"] = world.time
			signal.data["pressure"] = num2text(pressure)
			signal.data["carbon_dioxide"] = num2text(co2)
			radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, radio_filter = RADIO_AIRLOCK)
			previousPressure = pressure
			previousco2 = co2
			alert = (pressure < ONE_ATMOSPHERE*0.8) || (co2 > 1)
			update_icon()

/obj/machinery/airlock_sensor/co2/airlock_interior
	command = "cycle_interior"

/obj/machinery/airlock_sensor/co2/airlock_exterior
	command = "cycle_exterior"




////////// THERMAL POWER //////////////


/obj/machinery/power/rtg/fake_gen/geothermal
	name = "geothermal power generator"
	desc = "A large, mostly underground geothermal power generator. Generators power by venting steam through large turbines, creating a consistent and plentiful source of energy that can easily power a small outpost."
	icon = 'icons/obj/power_vrx96.dmi'
	icon_state = "geothermal"
	power_gen = 300000
	circuit = /obj/item/circuitboard/machine/rtg
	can_buckle = FALSE
	pixel_x = -32


/////////// AREAS //////////////////////

/area/submap/v5
	name = "\improper Virgo 5 Surface" //Nobody will know what this means if they see it, anyway.
	requires_power = 1
	dynamic_lighting = 1
	power_equip = FALSE
	power_environ = FALSE
	power_light = FALSE
	base_turf = /turf/simulated/floor/outdoors/snow/v5

/area/submap/v5/outdoors

/area/submap/v5/outpost_dome
	name = "\improper V5 Outpost Main Dome"

/area/submap/v5/outpost_whall
	name = "\improper V5 Outpost West Hall"

/area/submap/v5/outpost_wr1
	name = "\improper V5 Outpost West Room 1"

/area/submap/v5/outpost_wr2
	name = "\improper V5 Outpost West Room 2"

/area/submap/v5/outpost_wr3
	name = "\improper V5 Outpost West Room 3"

/area/submap/v5/outpost_nhall
	name = "\improper V5 Outpost Connecting Hall"

/area/submap/v5/outpost_airlock
	name = "\improper V5 Outpost Airlock"

/area/submap/v5/outpost_atmos
	name = "\improper V5 Outpost Atmospherics"

/area/submap/v5/outpost_engi
	name = "\improper V5 Outpost Engineering"

/area/submap/v5/outpost_engihall
	name = "\improper V5 Outpost Engineering Hall"

/area/submap/v5/outpost_power
	name = "\improper V5 Outpost Geothermal Power"

/area/submap/v5/outpost_bar
	name = "\improper V5 Outpost Bar"

/area/submap/v5/outpost_lpad
	name = "\improper V5 Outpost Landing Pad Near"

/area/submap/v5/outpost_lpad2
	name = "\improper V5 Outpost Landing Pad Large"

/area/submap/v5/caves
	name = "\improper V5 Caves"

/area/submap/v5/alien_ship
	name = "\improper V5 Alien Ship"

/area/submap/v5/mech_pod
	name = "\improper V5 Mech Pod"

