/obj/machinery/power/tesla_coil
	name = "tesla coil"
	desc = "Balanced power generation and zapping."
	icon = 'icons/obj/tesla_engine/tesla_coil.dmi'
	icon_state = "coil0"
	var/icontype = "coil"
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

/obj/machinery/power/tesla_coil/examine(mob/user)
	. = ..()
	if(anchored)
		. += span_notice("It has been securely bolted down and is ready for operation.")
	else
		. += span_warning("It is not secured!")

	if(Adjacent(user))
		if(input_power_multiplier != 1) //Greater than 1 or less than 1.
			. += span_info("This tesla coil will multiply any power it produces by [input_power_multiplier * 100]%.")
		if(power_loss != 1) //If set to 1, we don't lose power upon shooting the next.
			. += span_info("This tesla coil will divide power that it produces by [(1/power_loss) * 100]% when relaying it.")

/obj/machinery/power/tesla_coil/Initialize(mapload)
	. = ..()
	wires = new(src)

/obj/machinery/power/tesla_coil/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/power/tesla_coil/Destroy()
	QDEL_NULL(wires)
	return ..()

/obj/machinery/power/tesla_coil/RefreshParts()
	input_power_multiplier = 0
	zap_cooldown = 100
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		input_power_multiplier += C.rating
		zap_cooldown -= (C.rating * 20)

/obj/machinery/power/tesla_coil/update_icon()
	if(panel_open)
		icon_state = "[icontype]_open[anchored]"
	else
		icon_state = "[icontype][anchored]"

/obj/machinery/power/tesla_coil/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)

	//if(default_deconstruction_screwdriver(user, "coil_open[anchored]", "coil[anchored]", W))
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(default_unfasten_wrench(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return

	if(W?.has_tool_quality(TOOL_MULTITOOL))
		var/list/menu_list = list(
		"Normal",
		"Relay",
		"Splitter",
		"Amplifier",
		"Recaster",
		"Collector",
		)

		var/modification_decision = tgui_input_list(user, "Which tesla do you wish to change it into?", "Tesla Selection", menu_list)
		if(!modification_decision)
			return //They didn't select anything!
		if(QDELETED(src) || QDELETED(W) || QDELETED(user) || get_dist(user, src) > W.reach)
			return

		var/turf = get_turf(src)
		if(!turf)
			return
		var/obj/machinery/power/tesla_coil/new_coil
		switch(modification_decision)
			if("Normal")
				new_coil = new(turf)
			if("Relay")
				new_coil = new /obj/machinery/power/tesla_coil/relay(turf)
			if("Splitter")
				new_coil = new /obj/machinery/power/tesla_coil/splitter(turf)
			if("Amplifier")
				new_coil = new /obj/machinery/power/tesla_coil/amplifier(turf)
			if("Recaster")
				new_coil = new /obj/machinery/power/tesla_coil/recaster(turf)
			if("Collector")
				new_coil = new /obj/machinery/power/tesla_coil/collector(turf)
			else //Should never happen.
				return

		//Get rid of the stock parts that get added by init.
		for(var/obj/item/stock_parts/C in new_coil.component_parts)
			new_coil.component_parts -= C
			qdel(C)

		//Move the stock parts from the old coil to the new one.
		for(var/obj/item/stock_parts/C in component_parts)
			C.forceMove(new_coil)
			component_parts -= C
			new_coil.component_parts += C
		new_coil.RefreshParts()

		new_coil.anchored = anchored
		new_coil.update_icon()

		to_chat(user, span_notice("You modify \the [src]. It is now a [lowertext(modification_decision)]! You close the access panel."))
		qdel(src)
		return

	/* //Tesla wires do literally nothing.
	if(is_wire_tool(W))
		return wires.Interact(user)
	*/

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
	desc = "Designed to move power around rather. Creates no power on its own."
	icon_state = "relay0"
	icontype = "relay"

	circuit = /obj/item/circuitboard/tesla_coil

	power_loss = 1

	var/relay_efficiency = 0.9

/obj/machinery/power/tesla_coil/relay/RefreshParts()
	..()
	input_power_multiplier = 1 //So we don't show the examine text further above.
	relay_efficiency = 0.85
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		relay_efficiency += C.rating * 0.05

/obj/machinery/power/tesla_coil/relay/coil_act(var/power)
	var/power_relayed = power * relay_efficiency
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_relayed)

/obj/machinery/power/tesla_coil/relay/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += span_info("This tesla coil will multiply power transferring through it by [relay_efficiency * 100]%.")

/obj/machinery/power/tesla_coil/splitter
	name = "tesla prism coil"
	desc = "Acts as a multi-target distributor."
	icon_state = "prism0"
	icontype = "prism"

	circuit = /obj/item/circuitboard/tesla_coil

	var/split_count = 1

/obj/machinery/power/tesla_coil/splitter/RefreshParts()
	..()
	split_count = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		split_count += C.rating

/obj/machinery/power/tesla_coil/splitter/coil_act(var/power)
	var/power_per_bolt = power / (split_count + 1)
	var/power_produced = power_per_bolt / power_loss
	add_avail(power_produced*input_power_multiplier)
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	for(var/i = 0, i < split_count, i++)
		tesla_zap(src, 5, power_per_bolt)

/obj/machinery/power/tesla_coil/splitter/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += span_info("This tesla coil will create [split_count + 1] bolts, with each containing [(1 / (split_count+1)) * 100]% of the original power.")

/obj/machinery/power/tesla_coil/amplifier
	name = "tesla amplifier coil"
	desc = "Designed to amplify power moving through it rather than collecting it."
	icon_state = "amp0"
	icontype = "amp"

	circuit = /obj/item/circuitboard/tesla_coil

	var/amp_eff = 2.15
	power_loss = 1

/obj/machinery/power/tesla_coil/amplifier/RefreshParts()
	..()
	amp_eff = 1.15
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		amp_eff += C.rating

/obj/machinery/power/tesla_coil/amplifier/coil_act(var/power)
	var/power_produced = (power / 2) * amp_eff //T1 = 115% efficiency, T2 = 165%, T3 = 215%, T4 = 265%, T5 = 315%.
	add_avail(power / amp_eff) //'Designed to amplify power rather than collecting it'
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_produced)


/obj/machinery/power/tesla_coil/amplifier/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += span_info("This tesla coil will amplify any power it receives by [amp_eff * 100]% of the original power when relaying it.")
		. += span_info("This tesla coil will only produce [(1 / amp_eff) * 100]% of the power it receives.")

/obj/machinery/power/tesla_coil/recaster
	name = "tesla recaster coil"
	desc = "Extends the reach of the bolts."
	icon_state = "recaster0"
	icontype = "recaster"

	circuit = /obj/item/circuitboard/tesla_coil

	var/zap_range = 6

/obj/machinery/power/tesla_coil/recaster/RefreshParts()
	..()
	zap_range = 0
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		zap_range += C.rating * 6

/obj/machinery/power/tesla_coil/recaster/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += span_info("This tesla coil will extend the range of the bolt it produces by [zap_range] tiles.")

/obj/machinery/power/tesla_coil/recaster/coil_act(var/power)
	var/power_relayed = power / power_loss
	var/power_produced = power / (power_loss * 2)
	add_avail(power_produced*input_power_multiplier)
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = zap_range)
	tesla_zap(src, zap_range, power_relayed)

/obj/machinery/power/tesla_coil/collector
	name = "tesla collector coil"
	desc = "Highly efficient power collection. Does not arc."
	icon_state = "collector0"
	icontype = "collector"

	circuit = /obj/item/circuitboard/tesla_coil

	power_loss = 1 //Doesn't lose power. Instead it uses collect_eff

	var/collect_eff = 0.8

/obj/machinery/power/tesla_coil/collector/RefreshParts()
	..()
	collect_eff = 0.75
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		collect_eff += C.rating * 0.05

/obj/machinery/power/tesla_coil/collector/coil_act(var/power)
	var/power_produced = power * collect_eff
	add_avail(power_produced*input_power_multiplier)
	flick("[icontype]hit", src)
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)

/obj/machinery/power/tesla_coil/collector/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += span_info("This tesla coil will increase the power it produces by an additional [collect_eff * 100]% of the original power.")

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

/obj/machinery/power/grounding_rod/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)

/obj/machinery/power/grounding_rod/examine(user)
	. = ..()
	if(anchored)
		. += span_notice("It has been securely bolted down and is ready for operation.")
	else
		. += span_warning("It is not secured!")

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
