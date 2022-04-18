/obj/machinery/power/tesla_coil
	name = "tesla coil"
	desc = "For the union!"
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "coil0"
	anchored = FALSE
	density = TRUE

	// Executing a traitor caught releasing tesla was never this fun!
	can_buckle = TRUE
	buckle_lying = FALSE

	circuit = /obj/item/circuitboard/tesla_coil

	var/power_loss = 2
	var/input_power_multiplier = 1
	var/zap_cooldown = 100
	var/last_zap = 0
	var/datum/wires/tesla_coil/wires = null

/obj/machinery/power/tesla_coil/pre_mapped
	anchored = TRUE

/obj/machinery/power/tesla_coil/New()
	..()
	wires = new(src)

/obj/machinery/power/tesla_coil/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/power/tesla_coil/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/power/tesla_coil/RefreshParts()
	var/power_multiplier = 0
	zap_cooldown = 100
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		power_multiplier += C.rating
		zap_cooldown -= (C.rating * 20)
	input_power_multiplier = power_multiplier


/obj/machinery/power/tesla_coil/update_icon()
	if(panel_open)
		icon_state = "coil_open[anchored]"
	else
		icon_state = "coil[anchored]"

/obj/machinery/power/tesla_coil/attackby(obj/item/W, mob/user, params)
	src.add_fingerprint(user)

	//if(default_deconstruction_screwdriver(user, "coil_open[anchored]", "coil[anchored]", W))
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(default_unfasten_wrench(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(is_wire_tool(W))
		return wires.Interact(user)
	return ..()

/obj/machinery/power/tesla_coil/attack_hand(mob/user)
	if(user.a_intent == I_GRAB && user_buckle_mob(user.pulling, user))
		return
	..()

/obj/machinery/power/tesla_coil/tesla_act(var/power)
	if(anchored && !panel_open)
		being_shocked = TRUE
		//don't lose arc power when it's not connected to anything
		//please place tesla coils all around the station to maximize effectiveness
		var/power_produced = powernet ? power / power_loss : power
		add_avail(power_produced*input_power_multiplier)
		flick("coilhit", src)
		playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
		tesla_zap(src, 5, power_produced)
		//addtimer(CALLBACK(src, .proc/reset_shocked), 10)
		spawn(10) reset_shocked()
	else
		..()

/obj/machinery/power/tesla_coil/proc/zap()
	if((last_zap + zap_cooldown) > world.time || !powernet)
		return FALSE
	last_zap = world.time
	var/coeff = (20 - ((input_power_multiplier - 1) * 3))
	coeff = max(coeff, 10)
	var/power = (powernet.avail/2)
	draw_power(power)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 10, power/(coeff/2))

/obj/machinery/power/grounding_rod
	name = "grounding rod"
	desc = "Keep an area from being fried from Edison's Bane."
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "grounding_rod0"
	anchored = FALSE
	density = TRUE

	can_buckle = TRUE
	buckle_lying = FALSE
	circuit = /obj/item/circuitboard/grounding_rod

/obj/machinery/power/grounding_rod/pre_mapped
	anchored = TRUE

/obj/machinery/power/grounding_rod/update_icon()
	if(panel_open)
		icon_state = "grounding_rod_open[anchored]"
	else
		icon_state = "grounding_rod[anchored]"

/obj/machinery/power/grounding_rod/attackby(obj/item/W, mob/user, params)
	//if(default_deconstruction_screwdriver(user, "grounding_rod_open[anchored]", "grounding_rod[anchored]", W))
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(default_unfasten_wrench(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	return ..()

/obj/machinery/power/grounding_rod/attack_hand(mob/user)
	if(user.a_intent == I_GRAB && user_buckle_mob(user.pulling, user))
		return
	..()

/obj/machinery/power/grounding_rod/tesla_act(var/power)
	if(anchored && !panel_open)
		flick("grounding_rodhit", src)
	else
		..()
