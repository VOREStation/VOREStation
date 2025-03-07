/obj/machinery/holoplant
	name = "holoplant"
	desc = "One of those Ward-Takahashi holoplants! Give your space a bit of the comfort of being outdoors, by buying this blue buddy. A rugged case guarantees that your flower will outlive you, and variety of plant types won't let you to get bored along the way!"
	icon = 'icons/obj/holoplants.dmi'
	icon_state = "holopot"
	light_color = "#3C94C5"
	anchored = TRUE
	idle_power_usage = 0
	active_power_usage = 5
	var/interference = FALSE
	var/icon/plant = null
	var/global/list/possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13"
	)

/obj/machinery/holoplant/Initialize(mapload)
	. = ..()
	activate()

/obj/machinery/holoplant/attack_hand(var/mob/living/user)
	if(!istype(user) || interference)
		return

	if(!anchored)
		to_chat(user,span_warning("\The [src] must be anchored before activation!"))
		return

	if(!plant)
		activate()
	else
		deactivate()

/obj/machinery/holoplant/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_unfasten_wrench(user, O, 10))
		deactivate()
		return

	. = ..()

/obj/machinery/holoplant/proc/activate()
	if(!anchored || stat & (NOPOWER|BROKEN))
		return

	plant = prepare_icon(emagged ? "emagged" : null)
	cut_overlays()
	add_overlay(plant)
	set_light(2)
	update_use_power(USE_POWER_ACTIVE)

/obj/machinery/holoplant/proc/deactivate()
	cut_overlays()
	QDEL_NULL(plant)
	set_light(0)
	update_use_power(USE_POWER_OFF)

/obj/machinery/holoplant/power_change()
	..()
	if(stat & NOPOWER)
		deactivate()
	else
		activate()

/obj/machinery/holoplant/proc/flicker()
	interference = TRUE
	spawn(0)
		cut_overlays()
		set_light(0)
		sleep(rand(2,4))
		add_overlay(plant)
		set_light(2)
		sleep(rand(2,4))
		cut_overlays()
		set_light(0)
		sleep(rand(2,4))
		add_overlay(plant)
		set_light(2)
		interference = FALSE

/obj/machinery/holoplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)
	var/plant_icon = icon(icon, state)
	return getHologramIcon(plant_icon, 0)

/obj/machinery/holoplant/emag_act()
	if(emagged)
		return

	emagged = TRUE
	if(plant)
		deactivate()
	activate()

/obj/machinery/holoplant/Crossed(var/mob/living/L)
	if(!interference && plant && istype(L))
		flicker()


/obj/machinery/holoplant/shipped
	anchored = FALSE
/obj/machinery/holoplant/shipped/Initialize(mapload)
	. = ..()
