// the light switch
// can have multiple per area
// can also operate on non-loc area through "otherarea" var
/obj/machinery/light_switch
	name = "light switch"
	desc = "It turns lights on and off. What are you, simple?"
	icon = 'icons/obj/power_vr.dmi' // VOREStation Edit
	icon_state = "light1"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	power_channel = LIGHT
	blocks_emissive = FALSE
	vis_flags = VIS_HIDE // They have an emissive that looks bad in openspace due to their wall-mounted nature
	var/on = 1
	var/area/area = null
	var/otherarea = null
	var/image/overlay

/obj/machinery/light_switch/Initialize(mapload)
	. = ..()

	area = get_area(src)

	if(otherarea)
		area = locate(text2path("/area/[otherarea]"))

	if(!name)
		name = "light switch ([area.name])"

	on = area.lightswitch
	update_icon()

/obj/machinery/light_switch/Destroy()
	area = null
	overlay = null
	return ..()

/obj/machinery/light_switch/update_icon()
	cut_overlays()
	if(stat & NOPOWER)
		icon_state = "light-p"
		set_light(0)
	else
		icon_state = "light[on]"
		set_light(2, 0.1, on ? "#82FF4C" : "#F86060")
		. = list()
		. += emissive_appearance(icon, "light[on]-overlay")

	return add_overlay(.)


/obj/machinery/light_switch/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "A light switch. It is [on? "on" : "off"]."

/obj/machinery/light_switch/attack_hand(mob/user)

	on = !on

	area.lightswitch = on
	area.update_icon()
	playsound(src, 'sound/machines/button.ogg', 100, 1, 0) // VOREStation Edit

	for(var/obj/machinery/light_switch/L in area)
		L.on = on
		L.update_icon()

	area.power_change()
	GLOB.lights_switched_on_roundstat++

/obj/machinery/light_switch/power_change()

	if(!otherarea)
		if(powered(LIGHT))
			stat &= ~NOPOWER
		else
			stat |= NOPOWER

		update_icon()

/obj/machinery/light_switch/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	power_change()
	..(severity)

//Breakers for event maps

/obj/machinery/light_switch/breaker
	name = "lights breaker"
	desc = "A breaker for controlling power to the lights connected to the circuit."
	icon = 'icons/obj/power_breaker.dmi'
	icon_state = "light1"
	on = 0
