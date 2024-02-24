/obj/machinery/power/tesla_coil
	name = "tesla coil"
	desc = "For the union!"
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "coil0"
	var/icontype = "coil"
	anchored = FALSE
	density = TRUE

	// Executing a traitor caught releasing tesla was never this fun!
	can_buckle = TRUE
	buckle_lying = FALSE

	circuit = /obj/item/weapon/circuitboard/tesla_coil

	var/power_loss = 2
	var/input_power_multiplier = 1
	var/zap_cooldown = 100
	var/last_zap = 0
	var/datum/wires/tesla_coil/wires = null

/obj/machinery/power/tesla_coil/pre_mapped
	anchored = TRUE

/obj/machinery/power/tesla_coil/examine()
	. = ..()
	if(anchored)
		. += "<span class='notice'>It has been securely bolted down and is ready for operation.</span>"
	else
		. += "<span class='warning'>It is not secured!</span>"

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
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		power_multiplier += C.rating
		zap_cooldown -= (C.rating * 20)
	input_power_multiplier = power_multiplier


/obj/machinery/power/tesla_coil/update_icon()
	if(panel_open)
		icon_state = "[icontype]_open[anchored]"
	else
		icon_state = "[icontype][anchored]"

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
		coil_act(power)
		//addtimer(CALLBACK(src, PROC_REF(reset_shocked)), 10)
		spawn(10) reset_shocked()
	else
		..()

/obj/machinery/power/tesla_coil/proc/coil_act(var/power)
	var/power_produced = power / power_loss
	add_avail(power_produced*input_power_multiplier)
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_produced)

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

/obj/machinery/power/tesla_coil/relay
	name = "tesla relay coil"
	desc = "For the union!"
	icon_state = "relay0"
	icontype = "relay"

	circuit = /obj/item/weapon/circuitboard/tesla_coil

	power_loss = 1
	input_power_multiplier = 0

	var/relay_efficiency = 0.9

/obj/machinery/power/tesla_coil/relay/RefreshParts()
	..()
	var/relay_multiplier
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		relay_multiplier += C.rating
	relay_efficiency = 0.85 + (0.05 * relay_multiplier)

/obj/machinery/power/tesla_coil/relay/coil_act(var/power)
	var/power_relayed = power * relay_efficiency
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_relayed)

/obj/machinery/power/tesla_coil/splitter
	name = "tesla prism coil"
	desc = "For the union!"
	icon_state = "prism0"
	icontype = "prism"

	circuit = /obj/item/weapon/circuitboard/tesla_coil

	var/split_count = 1

/obj/machinery/power/tesla_coil/splitter/RefreshParts()
	..()
	split_count = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		split_count += C.rating

/obj/machinery/power/tesla_coil/splitter/coil_act(var/power)
	var/power_per_bolt = power / (split_count + 1)
	var/power_produced = power_per_bolt / power_loss
	add_avail(power_produced*input_power_multiplier)
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	for(var/i = 0, i < split_count, i++)
		tesla_zap(src, 5, power_per_bolt)

/obj/machinery/power/tesla_coil/amplifier
	name = "tesla amplifier coil"
	desc = "For the union!"
	icon_state = "amp0"
	icontype = "amp"

	circuit = /obj/item/weapon/circuitboard/tesla_coil

	var/amp_eff = 2

/obj/machinery/power/tesla_coil/amplifier/RefreshParts()
	..()
	var/amp_eff = 1
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		amp_eff += C.rating

/obj/machinery/power/tesla_coil/amplifier/coil_act(var/power)
	var/power_produced = power / power_loss
	add_avail(power_produced*input_power_multiplier)
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_produced)

/obj/machinery/power/tesla_coil/recaster
	name = "tesla recaster coil"
	desc = "For the union!"
	icon_state = "recaster0"
	icontype = "recaster"

	circuit = /obj/item/weapon/circuitboard/tesla_coil

	var/zap_range = 6

/obj/machinery/power/tesla_coil/recaster/RefreshParts()
	..()
	var/zap_range = 5
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		zap_range += C.rating

/obj/machinery/power/tesla_coil/recaster/coil_act(var/power)
	var/power_relayed = power / power_loss
	var/power_produced = power / (power_loss * 2)
	add_avail(power_produced*input_power_multiplier)
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = zap_range)
	tesla_zap(src, zap_range, power_relayed)

/obj/machinery/power/tesla_coil/collector
	name = "tesla collector coil"
	desc = "For the union!"
	icon_state = "collector0"
	icontype = "collector"

	circuit = /obj/item/weapon/circuitboard/tesla_coil

	var/collect_eff = 0.8

/obj/machinery/power/tesla_coil/collector/RefreshParts()
	..()
	var/collect_mod = 0
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		collect_mod += C.rating
	collect_eff = 0.75 + collect_mod*0.05

/obj/machinery/power/tesla_coil/collector/coil_act(var/power)
	var/power_produced = power * collect_eff
	add_avail(power_produced*input_power_multiplier)
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)

/obj/machinery/power/grounding_rod
	name = "grounding rod"
	desc = "Keep an area from being fried from Edison's Bane."
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "grounding_rod0"
	anchored = FALSE
	density = TRUE

	can_buckle = TRUE
	buckle_lying = FALSE
	circuit = /obj/item/weapon/circuitboard/grounding_rod

/obj/machinery/power/grounding_rod/examine()
	. = ..()
	if(anchored)
		. += "<span class='notice'>It has been securely bolted down and is ready for operation.</span>"
	else
		. += "<span class='warning'>It is not secured!</span>"

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
