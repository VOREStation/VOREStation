/obj/item/geiger //DISCLAIMER: I know nothing about how real-life Geiger counters work. This will not be realistic. ~Xhuis
	name = "\improper Geiger counter"
	desc = "A handheld device used for detecting and measuring radiation pulses."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "geiger_off"
	item_state = "multitool"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/inhands/equipment/tools_lefthand.dmi',
		slot_r_hand_str = 'icons/mob/inhands/equipment/tools_righthand.dmi',
		)
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	item_flags = NOBLUDGEON
	matter = list(/datum/material/steel = SHEET_MATERIAL_AMOUNT * 1.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 1.5)

	var/last_perceived_radiation_danger = null

	var/scanning = FALSE

	var/mounted = FALSE

/obj/item/geiger/Initialize(mapload)
	. = ..()

	RegisterSignal(src, COMSIG_IN_RANGE_OF_IRRADIATION, PROC_REF(on_pre_potential_irradiation))

/obj/item/geiger/examine(mob/user)
	. = ..()
	if(!scanning)
		return
	. += span_info("Alt-click it to clear stored radiation levels.")
	switch(last_perceived_radiation_danger)
		if(null)
			. += span_notice("Ambient radiation level count reports that all is well. It is ") + span_green("safe ") + span_notice("here.")
		if(PERCEIVED_RADIATION_DANGER_LOW)
			. += span_notice("Ambient radiation levels slightly above average. It is ") + span_green("safe ") + span_notice("here.")
		if(PERCEIVED_RADIATION_DANGER_MEDIUM)
			. += span_notice("Ambient radiation levels above average. It is ") + span_green("safe ") + span_notice("here.")
		if(PERCEIVED_RADIATION_DANGER_HIGH)
			. += span_suicide("Ambient radiation levels highly above average. It is ") + span_warning("unsafe ") + span_suicide("here.")
		if(PERCEIVED_RADIATION_DANGER_EXTREME)
			. += span_suicide("Ambient radiation levels reaching critical levels! It is ") + span_warning("extremely unsafe ") + span_suicide("here.")

/obj/item/geiger/update_icon()
	if(!scanning)
		icon_state = "geiger_off"
		return ..()

	switch(last_perceived_radiation_danger)
		if(null)
			icon_state = "geiger_on_1"
		if(PERCEIVED_RADIATION_DANGER_LOW)
			icon_state = "geiger_on_2"
		if(PERCEIVED_RADIATION_DANGER_MEDIUM)
			icon_state = "geiger_on_3"
		if(PERCEIVED_RADIATION_DANGER_HIGH)
			icon_state = "geiger_on_4"
		if(PERCEIVED_RADIATION_DANGER_EXTREME)
			icon_state = "geiger_on_5"
	return ..()

/obj/item/geiger/attack_self(mob/user)
	. = ..()
	if(.)
		return TRUE
	scanning = !scanning

	if (scanning)
		AddComponent(/datum/component/geiger_sound)
	else
		qdel(GetComponent(/datum/component/geiger_sound))

	update_icon()
	balloon_alert(user, "switch [scanning ? "on" : "off"]")

/obj/item/geiger/afterattack(atom/interacting_with, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(SHOULD_SKIP_INTERACTION(interacting_with, src, user))
		return NONE
	return attack_at_range(interacting_with, user, proximity_flag, click_parameters)

/obj/item/geiger/proc/attack_at_range(atom/interacting_with, mob/living/user, proximity_flag, click_parameters) //This is ranged_interact_with_atom on TG but we don't have that yet.
	if(!CAN_IRRADIATE(interacting_with))
		return NONE

	user.visible_message(span_notice("[user] scans [interacting_with] with [src]."), span_notice("You scan [interacting_with]'s radiation levels with [src]..."))
	addtimer(CALLBACK(src, PROC_REF(scan), interacting_with, user), 20, TIMER_UNIQUE) // Let's not have spamming GetAllContents
	return ITEM_INTERACT_SUCCESS

/obj/item/geiger/equipped(mob/user, slot, initial)
	. = ..()

	RegisterSignal(user, COMSIG_IN_RANGE_OF_IRRADIATION, PROC_REF(on_pre_potential_irradiation))

/obj/item/geiger/dropped(mob/user, silent = FALSE)
	. = ..()

	UnregisterSignal(user, COMSIG_IN_RANGE_OF_IRRADIATION)

/obj/item/geiger/proc/on_pre_potential_irradiation(datum/source, datum/radiation_pulse_information/pulse_information, insulation_to_target)
	SIGNAL_HANDLER

	last_perceived_radiation_danger = get_perceived_radiation_danger(pulse_information, insulation_to_target)
	addtimer(CALLBACK(src, PROC_REF(reset_perceived_danger)), TIME_WITHOUT_RADIATION_BEFORE_RESET, TIMER_UNIQUE | TIMER_OVERRIDE)

	if (scanning)
		update_icon()

/obj/item/geiger/proc/reset_perceived_danger()
	last_perceived_radiation_danger = null
	if (scanning)
		update_icon()

/obj/item/geiger/proc/scan(atom/target, mob/user)
	if (SEND_SIGNAL(target, COMSIG_GEIGER_COUNTER_SCAN, user, src) & COMSIG_GEIGER_COUNTER_SCAN_SUCCESSFUL)
		return

	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target.radiation)
			to_chat(user, span_notice("[icon2html(src, user)] [living_target] is reporting a radiation level of [living_target.radiation]."))
			return

	to_chat(user, span_notice("[icon2html(src, user)] [isliving(target) ? "Subject" : "Target"] is free of radioactive contamination."))

/obj/item/geiger/click_alt(mob/living/user)
	if(!scanning)
		to_chat(user, span_warning("[src] must be on to reset its radiation level!"))
		return CLICK_ACTION_BLOCKING
	to_chat(user, span_notice("You flush [src]'s radiation counts, resetting it to normal."))
	last_perceived_radiation_danger = null
	update_icon()
	return CLICK_ACTION_SUCCESS

/obj/item/geiger/wall
	name = "mounted geiger counter"
	desc = "A wall mounted device used for detecting and measuring radiation in an area."
	icon = 'icons/obj/device.dmi'
	icon_state = "geiger_wall"
	item_state = "geiger_wall"
	anchored = TRUE
	scanning = TRUE
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	w_class = ITEMSIZE_LARGE
	flags = NOBLOODY|WALL_ITEM
	var/circuit = /obj/item/circuitboard/geiger
	var/number = 0
	var/last_tick //used to delay the powercheck
	var/wiresexposed = FALSE
	mounted = TRUE

/obj/item/geiger/wall/Initialize(mapload)
	. = ..()
	if(scanning)
		AddComponent(/datum/component/geiger_sound)


/obj/item/geiger/wall/update_icon()
	if(!scanning)
		icon_state = "geiger_wall-p"
		return 1
	switch(last_perceived_radiation_danger)
		if(null)
			icon_state = "geiger_level_1"
		if(PERCEIVED_RADIATION_DANGER_LOW)
			icon_state = "geiger_level_2"
		if(PERCEIVED_RADIATION_DANGER_MEDIUM)
			icon_state = "geiger_level_3"
		if(PERCEIVED_RADIATION_DANGER_HIGH)
			icon_state = "geiger_level_4"
		if(PERCEIVED_RADIATION_DANGER_EXTREME)
			icon_state = "geiger_level_5"

/obj/item/geiger/wall/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/geiger/wall/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/geiger/wall/north
	pixel_y = 28
	dir = SOUTH

/obj/item/geiger/wall/south
	pixel_y = -28
	dir = NORTH

/obj/item/geiger/wall/east
	pixel_x = 28
	dir = EAST

/obj/item/geiger/wall/west
	pixel_x = -28
	dir = WEST
