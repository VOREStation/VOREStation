/*

Note that these have to be in the same /area that the controller is in for them to function.
You still need to set the controller's "id_tag" to something unique.
Any frequency works, it's self-setting, but it seems like people have decided 1380 for airlocks so maybe set that on the controller too.

*/

/obj/effect/map_helper/airlock
	name = "use a subtype!"
	icon = 'icons/misc/map_helpers.dmi'
	plane = 20 //I dunno just high.
	alpha = 170

	//The controller we're wanting our device to use
	var/obj/machinery/embedded_controller/radio/my_controller
	var/my_controller_type = /obj/machinery/embedded_controller/radio/airlock
	//The device we're setting up
	var/my_device
	var/my_device_type
	//Most things have a radio tag of some sort that needs adjusting
	var/tag_addon

/obj/effect/map_helper/airlock/Initialize()
	..()
	my_controller = get_controller(get_area(src))
	my_device = locate(my_device_type) in get_turf(src)
	if(!my_device)
		to_world("<b>[span_red("WARNING:")][span_black("Airlock helper '[name]' couldn't find what it wanted at: X:[x] Y:[y] Z:[z]")]</b>")
	else if(!my_controller)
		to_world("<b>[span_red("WARNING:")][span_black("Airlock helper '[name]' couldn't find a controller at: X:[x] Y:[y] Z:[z]")]</b>")
	else if(!my_controller.id_tag)
		to_world("<b>[span_red("WARNING:")][span_black("Airlock helper '[name]' found a controller without an 'id_tag' set: X:[x] Y:[y] Z:[z]")]</b>")
	else
		setup()
	return INITIALIZE_HINT_QDEL

/obj/effect/map_helper/airlock/Destroy()
	my_controller = null
	my_device = null
	return ..()

/obj/effect/map_helper/airlock/proc/get_controller(var/area/A)
	if(!A)
		return null

	var/list/potentials = list()
	for(var/obj/O in A)
		if(istype(O, my_controller_type))
			potentials += O

	//Couldn't find one
	if(!potentials.len)
		return null

	//Only found one
	if(potentials.len == 1)
		return potentials[1]

	//Gotta find closest
	var/closest = potentials[potentials.len]
	var/closest_dist = get_dist(src, closest)
	potentials.len--
	while(potentials.len)
		var/C = potentials[potentials.len]
		potentials.len--
		var/dist = get_dist(src, C)
		if(dist < closest_dist)
			closest_dist = dist
			closest = C

	return closest

/obj/effect/map_helper/airlock/proc/setup()
	return //Stub for subtypes


/*
	Doors
*/
/obj/effect/map_helper/airlock/door
	name = "use a subtype! - airlock door"
	my_device_type = /obj/machinery/door/airlock

/obj/effect/map_helper/airlock/door/setup()
	var/obj/machinery/door/airlock/my_airlock = my_device
	my_airlock.lock()
	my_airlock.id_tag = my_controller.id_tag + tag_addon
	my_airlock.frequency = my_controller.frequency
	my_airlock.set_frequency(my_controller.frequency)

/obj/effect/map_helper/airlock/door/ext_door
	name = "exterior airlock door"
	icon_state = "doorout"
	tag_addon = "_outer"

/obj/effect/map_helper/airlock/door/int_door
	name = "interior airlock door"
	icon_state = "doorin"
	tag_addon = "_inner"

/obj/effect/map_helper/airlock/door/simple
	name = "simple docking controller hatch"
	icon_state = "doorsimple"
	tag_addon = "_hatch"
	my_controller_type = /obj/machinery/embedded_controller/radio/simple_docking_controller


/*
	Atmos
*/
/obj/effect/map_helper/airlock/atmos
	name = "use a subtype! - airlock pump"
	my_device_type = /obj/machinery/atmospherics/unary/vent_pump

/obj/effect/map_helper/airlock/atmos/setup()
	var/obj/machinery/atmospherics/unary/vent_pump/my_pump = my_device
	my_pump.frequency = my_controller.frequency //Unlike doors, these set up their radios in atmos init, so they won't have gone before us.
	my_pump.id_tag = my_controller.id_tag + tag_addon

/obj/effect/map_helper/airlock/atmos/chamber_pump
	name = "chamber pump"
	icon_state = "pump"
	tag_addon = "_pump"

/obj/effect/map_helper/airlock/atmos/pump_out_internal
	name = "air dump intake"
	icon_state = "pumpdin"
	tag_addon = "_pump_out_internal"

/obj/effect/map_helper/airlock/atmos/pump_out_external
	name = "air dump output"
	icon_state = "pumpdout"
	tag_addon = "_pump_out_external"


/*
	Sensors - did you know they function as buttons? You don't also need a button.
*/
/obj/effect/map_helper/airlock/sensor
	name = "use a subtype! - airlock sensor"
	my_device_type = /obj/machinery/airlock_sensor
	var/command

/obj/effect/map_helper/airlock/sensor/setup()
	var/obj/machinery/airlock_sensor/my_sensor = my_device
	my_sensor.id_tag = my_controller.id_tag + tag_addon
	my_sensor.master_tag = my_controller.id_tag
	my_sensor.frequency = my_controller.frequency
	my_sensor.set_frequency(my_controller.frequency)
	if(command)
		my_sensor.command = command

/obj/effect/map_helper/airlock/sensor/ext_sensor
	name = "exterior sensor"
	icon_state = "sensout"
	tag_addon = "_exterior_sensor"
	command = "cycle_exterior"

/obj/effect/map_helper/airlock/sensor/chamber_sensor
	name = "chamber sensor"
	icon_state = "sens"
	tag_addon = "_sensor"
	command = "cycle"

/obj/effect/map_helper/airlock/sensor/int_sensor
	name = "interior sensor"
	icon_state = "sensin"
	tag_addon = "_interior_sensor"
	command = "cycle_interior"

/*
	Buttons
*/

/obj/effect/map_helper/airlock/buttons
	name = "Just use a sensor instead. They are actually buttons."
